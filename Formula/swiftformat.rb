class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.37.0.tar.gz"
  sha256 "4768319047c57faa262aa53b6ae71c9877482801e30803ac461c34239e175346"
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
