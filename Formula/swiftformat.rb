class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.48.13.tar.gz"
  sha256 "300042e4333eda97c8d12faeefb93f005b306b6f565f70b253a82f4a4bf90dfa"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e4aecadfb28959c9d17a97eb27e4ee858d66efbf919d9f63b8414de92374e0b1"
    sha256 cellar: :any_skip_relocation, big_sur:       "c30042a5d75297aecad26682532abc413d7dda54095a6e605edec56923087c25"
    sha256 cellar: :any_skip_relocation, catalina:      "7d38e056f8fba62e42f23cba8fd88dc2dcc6402b3fc4e2fbe2aec7799cc6f9c7"
    sha256 cellar: :any_skip_relocation, mojave:        "7cfda16897fbfde27298a7e5a6e228a31c5fef4964328e8db2ace60ea90cba68"
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
