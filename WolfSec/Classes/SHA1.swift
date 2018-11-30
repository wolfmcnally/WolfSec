//
//  SHA1.swift
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
#elseif canImport(CommonCryptoModule)
import CommonCryptoModule
#endif

import WolfPipe
import WolfFoundation

public struct SHA1 {
    private typealias `Self` = SHA1

    #if os(Linux)
    private static let digestLength = Int(SHA_DIGEST_LENGTH)
    #else
    private static let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
    #endif

    public private(set) var digest = Data(repeating: 0, count: Self.digestLength)

    public init(data: Data) {
        digest.withUnsafeMutableBytes { (digestPtr: UnsafeMutablePointer<UInt8>) in
            data.withUnsafeBytes { (dataPtr: UnsafePointer<UInt8>) in
                #if os(Linux)
                _ = COpenSSL.SHA1(dataPtr, data.count, digestPtr)
                #else
                CC_SHA1(dataPtr, CC_LONG(data.count), digestPtr)
                #endif
            }
        }
    }

    public static func test() {
        // $ openssl dgst -sha1 -hex
        // The quick brown fox\n^d
        // 16d17cfbec56708a1174c123853ad609a7e67cd8
        let data = "The quick brown fox\n" |> toUTF8
        let sha1 = data |> SHA1.init
        print(sha1)
        // prints 16d17cfbec56708a1174c123853ad609a7e67cd8
        let string = sha1.digest |> toHex
        print(string == "16d17cfbec56708a1174c123853ad609a7e67cd8")
        // prints true
    }
}

extension SHA1: CustomStringConvertible {
    public var description: String {
        return digest |> toHex
    }
}

extension String {
    public init(sha1: SHA1) {
        self.init(sha1.description)
    }
}
