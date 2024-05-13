#pragma once

#ifdef _WIN32
#  ifdef RT3DGE_Encoding_EXPORTS
#    define RT3DGE_Encoding_API __declspec(dllexport)
#  else
#    define RT3DGE_Encoding_API __declspec(dllimport)
#  endif
#else
#  define RT3DGE_Encoding_API
#endif

#include <string>
#include <unordered_map>

namespace RT3DGE_Encoding {
    // Function to encode a file, save the encoded file and the key file
    RT3DGE_Encoding_API void encodeFile(const std::string& inputFile, const std::string& outputFile, const std::string& keyFile);

    // Function to decode a file using the key file and save the decoded file
    RT3DGE_Encoding_API bool decodeAndVerify(const std::string& encodedFile, const std::string& keyFile, const std::string& outputDecodedFile);
}
