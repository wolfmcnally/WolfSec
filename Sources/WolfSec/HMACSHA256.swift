//
//  HMACSHA256.swift
//  WolfSec
//
//  Created by Wolf McNally on 4/20/17.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import WolfPipe
import WolfFoundation
import Foundation

#if canImport(COpenSSL)
import COpenSSL
#elseif canImport(CommonCrypto)
import CommonCrypto
#else
#error("No crypto library available.")
#endif

public func toHMACSHA256(key: Data) -> (_ data: Data) -> SHA256 {
    return { data in
        var digest = Data(repeating: 0, count: digestLengthSHA256)
        digest.withUnsafeMutableBytes { digestPtr in
            data.withUnsafeBytes { dataPtr in
                key.withUnsafeBytes { keyPtr in
                    #if canImport(COpenSSL)
                    _ = HMAC(EVP_sha256(), keyPtr, Int32(key.count), dataPtr, data.count, digestPtr, nil)
                    #else
                    CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), keyPtr.bindMemory(to: UInt8.self).baseAddress, key.count, dataPtr.bindMemory(to: UInt8.self).baseAddress, data.count, digestPtr.bindMemory(to: UInt8.self).baseAddress)
                    #endif
                }
            }
        }
        return try! digest |> tagSHA256
    }
}
