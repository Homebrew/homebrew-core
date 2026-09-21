class SwiftSection < Formula
  desc "CLI tool for parsing mach-o files to obtain Swift information"
  homepage "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection"
  url "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection/archive/refs/tags/0.19.0.tar.gz"
  sha256 "b6eca7a79efc1474200a006eb591a5f96fbe69d46905e4a9e5cffd1194c9563a"
  license "MIT"
  head "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f962055f88f9eb056adcec4d08157aa2fe02dd2aa4fab77018a2e34012d2bba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "63cc01397b042831f79df57949c8c227bcf3cbc3d22780b9be57c02c1d3566b6"
  end

  # The Package.swift file requires Swift 6.2 or later.
  # But it is failed to build on Sequoia with Xcode 26.3
  depends_on xcode: ["26.4", :build]
  depends_on macos: :tahoe # aligned to build Xcode as cannot cross-compile

  uses_from_macos "swift" => :build

  def install
    system "swift", "build", "--product", "swift-section", *std_swift_args
    bin.install ".build/release/swift-section"
    generate_completions_from_executable(bin/"swift-section", "--generate-completion-script")
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
