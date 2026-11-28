class SwiftSection < Formula
  desc "CLI tool for parsing mach-o files to obtain Swift information"
  homepage "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection"
  url "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection/archive/refs/tags/0.25.0.tar.gz"
  sha256 "49d959b5f36dfdb12f411a75ec53a2148f3ed7a4e0c518ba9b12e228635a5424"
  license "MIT"
  head "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "f33a7801b0a7f43c58b8e749b2d387ddaeaa80208d7d688d18eca3c412530085"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a27eb2b153feee43988b5e3a60950d530cd7f344b4f40f6d6509c160056ed24c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27cf48ae23eaf03ad08f271d8965c09cb9e4cb79260747cf05ab3f135cc420fa"
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
