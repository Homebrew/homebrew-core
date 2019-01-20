class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.37.3.tar.gz"
  sha256 "2efe3979f73fe4b47443a5e66710c44b7d60876393eb43c686eb15e4d383dc3e"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "7a660a2f354a07160d73078f01ab40cff476cff15d0074a4f0151c301e16be38" => :mojave
    sha256 "38ef9bed9d3c5a9ad25e7634d9e08e58b67c9f7f4ec9eac224b85e5f61592cf9" => :high_sierra
    sha256 "aebf30526cf6a8a36fb5a193c134bff51e267f1f9cc70aa1a42a9540774faa1f" => :sierra
  end

  depends_on :xcode => ["9.2", :build]

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
