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

import Foundation

#if canImport(COpenSSL)
    import COpenSSL
#elseif canImport(CommonCrypto)
    import CommonCrypto
#endif

import WolfPipe
import WolfFoundation

public struct HMACSHA256 {
    private typealias `Self` = HMACSHA256

    #if os(Linux)
    private static let digestLength = Int(SHA256_DIGEST_LENGTH)
    #else
    private static let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
    #endif

    public private(set) var digest = Data(repeating: 0, count: Self.digestLength)

    public init(data: Data, key: Data) {
        digest.withUnsafeMutableBytes { (digestPtr: UnsafeMutablePointer<UInt8>) in
            data.withUnsafeBytes { (dataPtr: UnsafePointer<UInt8>) in
                key.withUnsafeBytes { (keyPtr: UnsafePointer<UInt8>) in
                    #if os(Linux)
                        _ = HMAC(EVP_sha256(), keyPtr, Int32(key.count), dataPtr, data.count, digestPtr, nil)
                    #else
                        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), keyPtr, key.count, dataPtr, data.count, digestPtr)
                    #endif
                }
            }
        }
    }

    public static func test() {
        // $ openssl dgst -sha256 -hmac "secret"
        // The quick brown fox\n^d
        // 243d36ba44bbccad32ea644a4501cd62d425521165211ec86d55d91dc32c50fb
        let data = "The quick brown fox\n" |> toUTF8
        let key = "secret" |> toUTF8
        let hmac = (data, key) |> HMACSHA256.init
        print(hmac)
        // prints 243d36ba44bbccad32ea644a4501cd62d425521165211ec86d55d91dc32c50fb
        let string = hmac.digest |> toHex
        print(string == "243d36ba44bbccad32ea644a4501cd62d425521165211ec86d55d91dc32c50fb")
        // prints true
    }
}

extension HMACSHA256: CustomStringConvertible {
    public var description: String {
        return digest |> toHex
    }
}

extension String {
    public init(hmacsha256: HMACSHA256) {
        self.init(hmacsha256.description)
    }
}
