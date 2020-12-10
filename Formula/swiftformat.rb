class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.47.8.tar.gz"
  sha256 "c83f67a2d54cda4eeaa635b2719ed7b6f7af5d932c19da02467617902bdb9a16"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "8da7556c10052783559fbab05e8e95521a4c3f6072a32b8d35c25dcfe2284a62" => :big_sur
    sha256 "4ee65a999b56ebbae0d1d82733f9358bc5f3dddda7ef40e8459eabf7cbeedab1" => :catalina
    sha256 "0ec9cda25e86c50a9b9d8612b00428dc0b72f7c801b36d8addfced61da32bc54" => :mojave
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
