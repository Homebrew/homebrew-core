class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.48.14.tar.gz"
  sha256 "aba01d675a0fc068acb5501ce1861416a7c0172944847fe5ce2da34c989371c8"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2be041ccc1c3a9e942d44660d020ef6729dd8785def2237a454f0b6a02c910f8"
    sha256 cellar: :any_skip_relocation, big_sur:       "fefb8e8084529717a210a5e1405a89f9519d85f04fe4241fa470e3a6e7da7de0"
    sha256 cellar: :any_skip_relocation, catalina:      "7ae853e5979513ff30896baa13d3aa8f7a3e1bcb193c10d1f58af15150ca1911"
    sha256 cellar: :any_skip_relocation, mojave:        "7f2f475af19c01402dceedaaa8df8fed12c289aa9cd3c0d13bbdaf71c50fe163"
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
