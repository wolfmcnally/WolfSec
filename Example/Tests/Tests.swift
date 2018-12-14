import XCTest
import WolfSec
import WolfFoundation
import WolfPipe

class Tests: XCTestCase {
    func testMD5() {
        // $ openssl dgst -md5 -hex
        // The quick brown fox\n^d
        // e480132c9dd53e3e34e3cf9f523c7425
        XCTAssertTrue("The quick brown fox\n" |> toUTF8 |> toMD5 |> rawValue |> toHex == "e480132c9dd53e3e34e3cf9f523c7425" |> tagHex)
        XCTAssertThrowsError(try "0011223344" |> tagHex |> toData |> tagMD5)
    }

    func testSHA1() {
        // $ openssl dgst -sha1 -hex
        // The quick brown fox\n^d
        // 16d17cfbec56708a1174c123853ad609a7e67cd8
        XCTAssertTrue("The quick brown fox\n" |> toUTF8 |> toSHA1 |> rawValue |> toHex == "16d17cfbec56708a1174c123853ad609a7e67cd8" |> tagHex)
        XCTAssertThrowsError(try "0011223344" |> tagHex |> toData |> tagSHA1)
    }

    func testSHA256() {
        // $ openssl dgst -sha256 -hex
        // The quick brown fox\n^d
        // 35fb7cc2337d10d618a1bad35c7a9e957c213f00d0ed32f2454b2a99a971c0d8
        XCTAssertTrue("The quick brown fox\n" |> toUTF8 |> toSHA256 |> rawValue |> toHex == "35fb7cc2337d10d618a1bad35c7a9e957c213f00d0ed32f2454b2a99a971c0d8" |> tagHex)
        XCTAssertThrowsError(try "0011223344" |> tagHex |> toData |> tagSHA256)
    }

    func testHMACSHA256() {
        // $ openssl dgst -sha256 -hmac "secret"
        // The quick brown fox\n^d
        // 243d36ba44bbccad32ea644a4501cd62d425521165211ec86d55d91dc32c50fb
        let key = "secret" |> toUTF8
        XCTAssertTrue("The quick brown fox\n" |> toUTF8 |> toHMACSHA256(key: key) |> rawValue |> toHex == "243d36ba44bbccad32ea644a4501cd62d425521165211ec86d55d91dc32c50fb" |> tagHex)
    }
}
