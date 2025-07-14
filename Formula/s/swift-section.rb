class SwiftSection < Formula
  desc "CLI tool for parsing mach-o files to obtain Swift information"
  homepage "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection"
  url "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection/archive/refs/tags/0.6.0.tar.gz"
  sha256 "b4dc871bf5c712ca49d22c738c481285f9e4b835f300f2a3b76e5588edfdaa8f"
  license "MIT"
  head "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e0ea2815a7b598314f27fd6106b276e73e2c860df3aae1c650110f8b4601095"
  end

  # The Package.swift file requires Swift 5.10 or later.
  # But it is actually only builable with Swift 6.1+ due to the usage of trailing commma in comma-separated lists.
  depends_on xcode: ["16.3", :build]
  depends_on :macos

  uses_from_macos "swift" => :build

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/swift-section"
  end

  test do
    (testpath/"test.swift").write <<~SWIFT
      public struct MyTestStruct {
          public let id: Int
          public let name: String
          public init(id: Int, name: String) {
              self.id = id
              self.name = name
          }
      }
    SWIFT

    system "swiftc", "-emit-library", "-module-name", "Test", "Test.swift", "-o", "libTest.dylib"
    system bin/"swift-section", "dump", "libTest.dylib", "-o", "output.txt", "-s", "types"
    assert_match "MyTestStruct", (testpath/"output.txt").read
  end
end
