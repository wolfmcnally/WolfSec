//
//  MD5.swift
//  WolfSec
//
//  Created by Wolf McNally on 4/19/17.
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

public struct MD5 {
  private typealias `Self` = MD5

  #if os(Linux)
  private static let digestLength = Int(MD5_DIGEST_LENGTH)
  #else
  private static let digestLength = Int(CC_MD5_DIGEST_LENGTH)
  #endif

    public private(set) var digest = Data(repeating: 0, count: Self.digestLength)

    public init(data: Data) {
        digest.withUnsafeMutableBytes { (digestPtr: UnsafeMutablePointer<UInt8>) in
            data.withUnsafeBytes { (dataPtr: UnsafePointer<UInt8>) in
                #if os(Linux)
                    _ = COpenSSL.MD5(dataPtr, data.count, digestPtr)
                #else
                    CC_MD5(dataPtr, CC_LONG(data.count), digestPtr)
                #endif
            }
        }
    }

    public static func test() {
        // $ openssl dgst -md5 -hex
        // The quick brown fox\n^d
        // e480132c9dd53e3e34e3cf9f523c7425
        let data = "The quick brown fox\n" |> toUTF8
        let md5 = data |> MD5.init
        print(md5)
        // prints e480132c9dd53e3e34e3cf9f523c7425
        let string = md5.digest |> toHex
        print(string == "e480132c9dd53e3e34e3cf9f523c7425")
        // prints true
    }
}

extension MD5: CustomStringConvertible {
    public var description: String {
        return digest |> toHex
    }
}

extension String {
    public init(md5: MD5) {
        self.init(md5.description)
    }
}
