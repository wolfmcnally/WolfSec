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

import WolfPipe
import WolfFoundation

#if canImport(COpenSSL)
import COpenSSL
public let digestLengthSHA256 = Int(SHA256_DIGEST_LENGTH)
#elseif canImport(CommonCrypto)
import CommonCrypto
public let digestLengthSHA256 = Int(CC_SHA256_DIGEST_LENGTH)
#else
#error("No crypto library available.")
#endif

public enum SHA256Tag { }
public typealias SHA256 = Tagged<SHA256Tag, Data>

public func tagSHA256(_ data: Data) throws -> SHA256 {
    guard data.count == digestLengthSHA256 else { throw WolfSecError("Invalid length for SHA256 hash") }
    return SHA256(rawValue: data)
}

public func toSHA256(_ data: Data) -> SHA256 {
    var digest = Data(repeating: 0, count: digestLengthSHA256)
    digest.withUnsafeMutableBytes { (digestPtr: UnsafeMutablePointer<UInt8>) in
        data.withUnsafeBytes { (dataPtr: UnsafePointer<UInt8>) in
            #if canImport(COpenSSL)
            _ = COpenSSL.SHA256(dataPtr, data.count, digestPtr)
            #else
            CC_SHA256(dataPtr, CC_LONG(data.count), digestPtr)
            #endif
        }
    }
    return try! digest |> tagSHA256
}
