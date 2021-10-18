class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.48.17.tar.gz"
  sha256 "b0c81730a4b19e76057e5f9b781d124d5ca697bb80cde7638ea3c6fc8b8d2ed0"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6e754174bb20c391ccebe2685d1ab2dcba66020f0bb0eb118c09272d9daebbbd"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6d4e1a74a8904358df45ea9cc694dbf9b228e6fcf1bcf88bb9f5e18681411ac"
    sha256 cellar: :any_skip_relocation, catalina:      "c88cdbc2ade1ad4635fdafcb9b3ad23b6ba12aa50f5507bd2615dca2f9d21530"
    sha256 cellar: :any_skip_relocation, mojave:        "0a4d4a8b561e961e8cd98c216fb4589cbbcf127c26fc25c81f794360295950ec"
  end

  depends_on xcode: ["10.1", :build]
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
        "-project", "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "-configuration", "Release",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
