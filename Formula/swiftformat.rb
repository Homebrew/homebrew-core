class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.31.0.tar.gz"
  sha256 "e4d0b982bd41585848cb4ba6c011604967f4898726b2d6f2596be3f50ac546b1"

  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "ec5ca87e75766271893bfd58980ac68a73c763c08c68043d8b5ce02761648414" => :high_sierra
    sha256 "f0282f83b4faf0aa288aefc87aa2b21ee17788d82d132cb29d696e32249242f7" => :sierra
  end

  depends_on :xcode => ["9.0", :build]

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
