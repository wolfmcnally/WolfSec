//
//  SHA256.swift
//  WolfSec
//
//  Created by Wolf McNally on 1/20/16.
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

public struct SHA256 {
    private typealias `Self` = SHA256

    #if os(Linux)
    private static let digestLength = Int(SHA256_DIGEST_LENGTH)
    #else
    private static let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
    #endif

    public private(set) var digest = Data(repeating: 0, count: Self.digestLength)

    public init(data: Data) {
        digest.withUnsafeMutableBytes { (digestPtr: UnsafeMutablePointer<UInt8>) in
            data.withUnsafeBytes { (dataPtr: UnsafePointer<UInt8>) in
                #if os(Linux)
                    _ = COpenSSL.SHA256(dataPtr, data.count, digestPtr)
                #else
                    CC_SHA256(dataPtr, CC_LONG(data.count), digestPtr)
                #endif
            }
        }
    }

    public static func test() {
        // $ openssl dgst -sha256 -hex
        // The quick brown fox\n^d
        // 35fb7cc2337d10d618a1bad35c7a9e957c213f00d0ed32f2454b2a99a971c0d8
        let data = "The quick brown fox\n" |> toUTF8
        let sha256 = data |> SHA256.init
        print(sha256)
        // prints 35fb7cc2337d10d618a1bad35c7a9e957c213f00d0ed32f2454b2a99a971c0d8
        let string = sha256.digest |> toHex
        print(string == "35fb7cc2337d10d618a1bad35c7a9e957c213f00d0ed32f2454b2a99a971c0d8")
        // prints true
    }
}

extension SHA256: CustomStringConvertible {
    public var description: String {
        return digest |> toHex
    }
}

extension String {
    public init(sha256: SHA256) {
        self.init(sha256.description)
    }
}
