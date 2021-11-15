class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.48.18.tar.gz"
  sha256 "bf1da27748d31ce691678bee21352cecfda74a591de55494036d7b20bba844dc"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adbb11cdda0596a1f40e920f826a2e1ffe6aeb1643c43ddb108f25f30755be39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74691b21c40d34459c5825306828039bdbdfdd02c80d1cea5c449c3f59760ab1"
    sha256 cellar: :any_skip_relocation, monterey:       "14e4b90f29b55b06c92f90b6e81e8dd55c54ff258ee8b0bab2bb479ce0cc8daf"
    sha256 cellar: :any_skip_relocation, big_sur:        "73f0497b504f87159bc2d133371014e0372799d89f62bc78068b3b5427ae614f"
    sha256 cellar: :any_skip_relocation, catalina:       "11543d157b589acdf9de93133a68fa32aa00372b574a64c40292aead20f6f6cb"
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
