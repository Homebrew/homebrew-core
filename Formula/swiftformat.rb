class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.47.12.tar.gz"
  sha256 "1cb49dfec1dddeeec130b15c949072b288ee30e8fb1e828ee4e4851df3891a78"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "334b736f7c78b1bc48882f55558e79571be591281462bc91dedea6dac10034be"
    sha256 cellar: :any_skip_relocation, big_sur:       "b7ba5043f29c548dd05374125faa61dd07690bffe373890cb608609e4a7e2413"
    sha256 cellar: :any_skip_relocation, catalina:      "030b2e18168f5680c4ee387812b14057c4cb148b6f6800b983b1b298f4af15b1"
    sha256 cellar: :any_skip_relocation, mojave:        "b3e35821d3094d08eb9f8423ce7d18cb5462bb5b1d02a3156ed1a10f6539709a"
  end

  depends_on xcode: ["10.1", :build]

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
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
