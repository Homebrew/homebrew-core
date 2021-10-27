class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.48.17.tar.gz"
  sha256 "b0c81730a4b19e76057e5f9b781d124d5ca697bb80cde7638ea3c6fc8b8d2ed0"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4472d6a696d91edb873b718181d8110fe4d202e91c8ef0ffbf6cb3fe73f29c64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e19dbc72ddf213203e940708f3de6d9ca9c88663b5176494d04b4c418e16954f"
    sha256 cellar: :any_skip_relocation, monterey:       "f0a9343a74cdc3f8a3736d0769264feb7e5a4dbdf0ace30eb2a2dea5cadc1c04"
    sha256 cellar: :any_skip_relocation, big_sur:        "90056a4e3b03ef31cecfb5b9e278a44bea2abecdd26a202d00bc390dfbbeb352"
    sha256 cellar: :any_skip_relocation, catalina:       "9647fdbfed2e7e2361974a5bfb99be4a112d914bd3e582afb4cdf7dc81e44cbf"
    sha256 cellar: :any_skip_relocation, mojave:         "83231c218cca811795688e175d88ac4584d1c424566926f9d6ed36e9dbdfed75"
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
