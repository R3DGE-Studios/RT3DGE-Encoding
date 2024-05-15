#include "RT3DGE_Encoding.hpp"
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
int main() {
    std::string inputFile = "input.txt";
    std::string outputFile = "output.txt";
    std::string keyFile = "key.json";
    std::string decodedFile = "decoded.txt";

    try {
        // Encode the file
        RT3DGE_Encoding::encodeFile(inputFile, outputFile, keyFile);
        std::cout << "File encoded successfully." << std::endl;

        // Decode and verify the file
        bool isVerified = RT3DGE_Encoding::decodeAndVerify(outputFile, keyFile, decodedFile);
        if (isVerified) {
            std::cout << "Decoded file verified successfully. Hash matches." << std::endl;
        } else {
            std::cout << "Decoded file verification failed. Hash does not match." << std::endl;
        }

    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }

    return 0;
}