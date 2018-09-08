class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.35.5.tar.gz"
  sha256 "1035ee8ab569e4e49617bc730d05a28e4d08162149001cf7a18ce9c482263f3e"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "4f0036830148e4576061d223cd825009698fffade07cba27cdd3092fe7364877" => :mojave
    sha256 "2cc1b17fed2c4cb8ba85cd7bc71bcc656c7b7c7a3a69b6f8dcea2adc32c7aa75" => :high_sierra
    sha256 "c6d9bcb42ecd9a7bd778a77ec0047ddcc4d31350cb712b60e9ff976a6c9ff02a" => :sierra
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
