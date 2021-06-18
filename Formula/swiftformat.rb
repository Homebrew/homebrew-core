class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.48.5.tar.gz"
  sha256 "8c02c1c61c6a6ad37182d72f2f9f6bf193f4f3aea84540795f0901f472dff8d7"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7619ac8360774b9854b838912b43b8d7be9dfd39a2cf4bdd24afbc2007cd6bd8"
    sha256 cellar: :any_skip_relocation, big_sur:       "c50e89c6fd21e817cdf5f1b1d0a51c25553e0d5bcb396fe18e6404f4ad31c2b8"
    sha256 cellar: :any_skip_relocation, catalina:      "41d5ecd73bba3c90c8770d33dc86fb0a07f9fb23034d1b07517e7dd9431e8280"
    sha256 cellar: :any_skip_relocation, mojave:        "369cb9a0eca80fc8fd0ae5a1dcf6dad9aea366d3325e196276b05b9abb392357"
  end

  depends_on xcode: ["10.1", :build]

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
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
