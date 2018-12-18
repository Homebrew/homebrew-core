class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.37.1.tar.gz"
  sha256 "8d2f0aef108e1ff01afbd92c7cc034c58e1d030d8a5dd790c58e19b07bf36fc9"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "13fbcef9056df677b661c79c23e51970c13d5621a33e2a3b8d08fd65570429c9" => :mojave
    sha256 "ed218bf7fb4dd6a8ef3ae4f8c6aedaf39be3492357b9da7c8f2dc8250c6b27a1" => :high_sierra
    sha256 "76dd482318aafe2e5751c3629cadb0a44f8a3b983d03ddd4ae997fabec7e0b47" => :sierra
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
