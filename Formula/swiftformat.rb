class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.47.12.tar.gz"
  sha256 "1cb49dfec1dddeeec130b15c949072b288ee30e8fb1e828ee4e4851df3891a78"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "65a20f75d4a9e2837dfc60318e312893b99f2a957a7f3a9a137b326c87dc29ff"
    sha256 cellar: :any_skip_relocation, big_sur:       "0b4c55f9316fbf40c9eab826536df17eb0249484772c372a962a189e0d1a7fd2"
    sha256 cellar: :any_skip_relocation, catalina:      "3b7bc3e4e6f150ecdd298be109d13ef9e84a56a45c580113c7a6b151fe1615da"
    sha256 cellar: :any_skip_relocation, mojave:        "24bdfac40c16c1e40bbe970eedb9450cd3099890188b8d6bdd0fe2447d54ce48"
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
