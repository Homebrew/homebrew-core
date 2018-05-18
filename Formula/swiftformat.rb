class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.33.7.tar.gz"
  sha256 "e48534f2d2df4cc02dacdfb1af8653a8e1d1399685f8b38bf3a9ba7990cdf343"

  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "352c3d512e1dfcf832bbdf3c8aa5e1a8fd77c33924e6d7d7ff25ec843d02e1d5" => :high_sierra
    sha256 "cd4c61865e95492a04f573f9bfb7bdd7db80338cf0c1f458ea83eea85bb921e4" => :sierra
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
