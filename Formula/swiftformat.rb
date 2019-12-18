class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.43.0.tar.gz"
  sha256 "235ce27ec394e1a655b84ca3e73f033c1f859ae64c1273dff8e27711f9e52f82"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "68856593233e0383034b8c8c4589cc2fded234f39d9696fab9dcec36008a2ca6" => :catalina
    sha256 "1fa0951033c8c7e6157445d44170266d1117a97986922b17e14e94ffe8dfbf19" => :mojave
    sha256 "f23095ed3821db83f1979c9251855be2b77568a9eecd7874f55fd90c93bcf004" => :high_sierra
  end

  depends_on :xcode => ["10.1", :build]

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
