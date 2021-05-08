class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.48.1.tar.gz"
  sha256 "dc7f396f85261fe36302e66d94405d0637b11f304e9bd635a7bb7b087b5117f0"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bca1fc4ac0264ff950c14eb3c72c0fa321baa99fb60178266da19b680d67147b"
    sha256 cellar: :any_skip_relocation, big_sur:       "fa1af90b137298039eab4205a9a8733fbba4f9e5cf0322197674ce6f1582f0e0"
    sha256 cellar: :any_skip_relocation, catalina:      "35bc84d95bcd8e5066669c6383f999507b1d1a8a08f3aae321f89e2944ea39e2"
    sha256 cellar: :any_skip_relocation, mojave:        "b5274f542e17907e806ca6e6d1ca630a538bc2e98330329bca5a1568d76a7267"
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
