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

import WolfCore

#if canImport(COpenSSL)
import COpenSSL
public let digestLengthMD5 = Int(MD5_DIGEST_LENGTH)
#elseif canImport(CommonCrypto)
import CommonCrypto
public let digestLengthMD5 = Int(CC_MD5_DIGEST_LENGTH)
#else
#error("No crypto library available.")
#endif

public enum MD5Tag { }
public typealias MD5 = Tagged<MD5Tag, Data>

public func tagMD5(_ data: Data) throws -> MD5 {
    guard data.count == digestLengthMD5 else { throw WolfSecError("Invalid length for MD5 hash") }
    return MD5(rawValue: data)
}

public func toMD5(_ data: Data) -> MD5 {
    var digest = Data(repeating: 0, count: digestLengthMD5)
    digest.withUnsafeMutableBytes { digestPtr in
        data.withUnsafeBytes { dataPtr in
            #if canImport(COpenSSL)
            _ = COpenSSL.MD5(dataPtr, data.count, digestPtr)
            #else
            CC_MD5(dataPtr.bindMemory(to: UInt8.self).baseAddress, CC_LONG(data.count), digestPtr.bindMemory(to: UInt8.self).baseAddress)
            #endif
        }
    }
    return try! digest |> tagMD5
}
