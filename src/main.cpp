#include <iostream>
#include <fstream>
#include <unordered_map>
#include <vector>
#include <sstream>
#include <codecvt>
#include <locale>
#include <nlohmann/json.hpp>
#include <openssl/sha.h>
#include <random>
#include "RT3DGE_Encoding.hpp"

namespace RT3DGE_Encoding {
    // Function to read the entire file content into a UTF-8 string
    std::u32string readFile(const std::string& filename) {
        std::ifstream file(filename, std::ios::binary);
        if (!file.is_open()) {
            throw std::runtime_error("Could not open file for reading.");
        }

        std::ostringstream contents;
        contents << file.rdbuf();
        std::string utf8str = contents.str();
        
        std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> converter;
        return converter.from_bytes(utf8str);
    }

    // Function to write a UTF-8 string to a file
    void writeFile(const std::string& filename, const std::u32string& content) {
        std::ofstream file(filename, std::ios::binary);
        if (!file.is_open()) {
            throw std::runtime_error("Could not open file for writing.");
        }

        std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> converter;
        file << converter.to_bytes(content);
    }

    // Function to generate a random UTF-8 character (for simplicity, using ASCII range here)
    char32_t generateRandomCharacter() {
        static std::random_device rd;
        static std::mt19937 gen(rd());
        static std::uniform_int_distribution<> dis(33, 126); // Printable ASCII range
        return static_cast<char32_t>(dis(gen));
    }

    // Function to compute SHA-256 hash of a string
    std::string computeSHA256(const std::string& str) {
        unsigned char hash[SHA256_DIGEST_LENGTH];
        SHA256_CTX sha256;
        SHA256_Init(&sha256);
        SHA256_Update(&sha256, str.c_str(), str.size());
        SHA256_Final(hash, &sha256);

        std::ostringstream result;
        for (int i = 0; i < SHA256_DIGEST_LENGTH; ++i) {
            result << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(hash[i]);
        }
        return result.str();
    }

    // Function to encode a file, save the encoded file and the key file
    void encodeFile(const std::string& inputFile, const std::string& outputFile, const std::string& keyFile) {
        std::u32string content = readFile(inputFile);

        std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> converter;
        std::string originalUtf8 = converter.to_bytes(content);

        std::string fileHash = computeSHA256(originalUtf8);

        std::unordered_map<char32_t, char32_t> substitutionMap;
        std::unordered_map<char32_t, char32_t> reverseMap;
        std::u32string transformedContent;

        for (char32_t ch : content) {
            if (substitutionMap.find(ch) == substitutionMap.end()) {
                char32_t newChar = generateRandomCharacter();
                while (reverseMap.find(newChar) != reverseMap.end()) {
                    newChar = generateRandomCharacter();
                }
                substitutionMap[ch] = newChar;
                reverseMap[newChar] = ch;
            }
            transformedContent.push_back(substitutionMap[ch]);
        }

        writeFile(outputFile, transformedContent);

        nlohmann::json keyJson;
        keyJson["file_hash"] = fileHash;
        for (const auto& pair : substitutionMap) {
            keyJson["mapping"][std::to_string(pair.first)] = std::to_string(pair.second);
        }

        std::ofstream keyOut(keyFile);
        if (!keyOut.is_open()) {
            throw std::runtime_error("Could not open key file for writing.");
        }
        keyOut << keyJson.dump(4);
    }

    // Function to decode the file using the key from the JSON file and verify hash
    bool decodeAndVerify(const std::string& encodedFile, const std::string& keyFile, const std::string& outputDecodedFile) {
        std::ifstream keyIn(keyFile);
        if (!keyIn.is_open()) {
            throw std::runtime_error("Could not open key file for reading.");
        }
        
        nlohmann::json keyJson;
        keyIn >> keyJson;

        std::string fileHash = keyJson["file_hash"];
        std::unordered_map<std::string, std::string> mapping = keyJson["mapping"].get<std::unordered_map<std::string, std::string>>();
        
        std::u32string encodedContent = readFile(encodedFile);
        std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> converter;
        
        std::unordered_map<char32_t, char32_t> reverseMap;
        for (const auto& pair : mapping) {
            reverseMap[std::stoul(pair.second)] = std::stoul(pair.first);
        }
        
        std::u32string decodedContent;
        for (char32_t ch : encodedContent) {
            if (reverseMap.find(ch) != reverseMap.end()) {
                decodedContent.push_back(reverseMap[ch]);
            } else {
                decodedContent.push_back(ch);
            }
        }
        
        writeFile(outputDecodedFile, decodedContent);
        
        std::string decodedUtf8 = converter.to_bytes(decodedContent);
        std::string decodedHash = computeSHA256(decodedUtf8);
        
        return decodedHash == fileHash;
    }
}
