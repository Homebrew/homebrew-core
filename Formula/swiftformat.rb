class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.47.8.tar.gz"
  sha256 "c83f67a2d54cda4eeaa635b2719ed7b6f7af5d932c19da02467617902bdb9a16"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "47e3aa92792a53413eb0866d3b6709e88c7164184f406c3e49c560e82a2fe589" => :big_sur
    sha256 "c268a44da4ed4e7836d2b43f917a1411f3b8f13488ee25c66f4bd8bb2f4d5e05" => :catalina
    sha256 "38abb30c870974c65ee0a3afed11cd5f983ab05a13923061fc67c4b6566df6f8" => :mojave
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
