class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.40.3.tar.gz"
  sha256 "b731e7c8e7feb8228d4306fc388eb1220d941e22ad8f49d041d7d36e78ff83f5"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "4ca43ed715ecdfddda08afc14a433370a821b42840ca6d702a737d387da70dca" => :mojave
    sha256 "9dabbc40392fcb6f415471cbd406db3495f098e0ae9dd93971f02c2d8a9859ff" => :high_sierra
    sha256 "7e259bd0ee4ba03e16c181857254f11b0e6f9c60bf7724e22db02a9c663d42a4" => :sierra
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
