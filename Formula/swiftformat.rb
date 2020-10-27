class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.47.1.tar.gz"
  sha256 "87fe832767e75eb4c14a3bdb963e569d33882d633ada83c5ae1b90332aea50a2"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "0cc7debbd4f6b2897974b2cabd329d5f03e86f358bb3af043a13ed2607268096" => :catalina
    sha256 "943963b0b762d64581ff38c6937847d08f0cc0d1493683b1d62f60e6a3871c6f" => :mojave
    sha256 "26b4bdce98359f96965cebcdf74a39080a5f3cc99a198f0d68d08f9c99ecfc26" => :high_sierra
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
