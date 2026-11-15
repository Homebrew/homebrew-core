class SwiftSection < Formula
  desc "CLI tool for parsing mach-o files to obtain Swift information"
  homepage "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection"
  url "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection/archive/refs/tags/0.24.0.tar.gz"
  sha256 "173bf8163d07e639853e46491fe9ab956033013d7b320a9bf2e30d082eef0e4e"
  license "MIT"
  head "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "849b442491b51a2908c8f5d91c79de2f33200b70c14e4ebb53e0881b8bfaad6f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b651174c849262b81a25126cb0c858ebc6dfbed171e86a1cbd371b9684c97918"
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
