class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.40.4.tar.gz"
  sha256 "0e11500bf82390b8ac3065c480ab561763adc4096e6f04d0c277d6df5b294b74"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "7c0d9893b89f200319bfd4cfe8fe3cf942f85f2914c236b18ec9b67ffe1e6e34" => :mojave
    sha256 "885e505fd201bc1055af6a4a3a077590675886eb897893b8762b390d162d3521" => :high_sierra
    sha256 "ab6f2c65661b1cec3958d7e0687e79e05a271af17d30e5082312bc454b4352d2" => :sierra
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
