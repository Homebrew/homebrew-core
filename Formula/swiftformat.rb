class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.33.1.tar.gz"
  sha256 "caf7663b26858567680577de3a70249a95d17bf0047cc380654491cd0e8c686d"

  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "3ec6a15b9924eb2b5b9aa21a2ffca6f386e4f3c819265ea47ce2d3fca98fb85d" => :high_sierra
    sha256 "564741c912ec006bd814743f39436df1c6b6910300fbd850e36e41aecfa4d6e6" => :sierra
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
