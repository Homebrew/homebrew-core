class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.48.11.tar.gz"
  sha256 "e094d9dcfa377d327fa53316b60776b47944d93fb85ae8e1ba217a954d95eeba"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d46373d76174d0022b497e22392f4c5d95129ee8f961c1e5207654bebed38b79"
    sha256 cellar: :any_skip_relocation, big_sur:       "822e0d0e6a6aabf3d65b3814daf7fd669358d34916307b6797de34f6c42fb4fa"
    sha256 cellar: :any_skip_relocation, catalina:      "785b013e0ce2a08ca2cd49e895222690b1d446cc24496cdb0f9a3202c44d5b02"
    sha256 cellar: :any_skip_relocation, mojave:        "bf87cc773f55f0315c0a94db459431bc1f925170eb2692309148e88d46777399"
  end

  depends_on xcode: ["10.1", :build]

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
