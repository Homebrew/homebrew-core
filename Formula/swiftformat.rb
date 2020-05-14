class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.10.tar.gz"
  sha256 "82c740a426571fcef52f0f46f9bff5460442f78cedccc929e0a87dbab4933c8a"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "20066e7f5becea0099f05dc510634d5193799c4bb5e0e25d6fc6be318e812964" => :catalina
    sha256 "ff9622c427d88dadc5b0f6348d47044e85ba45e55449ca506687b3773172e2d1" => :mojave
    sha256 "2dab824409448a41181ae6e41bd6e6a32f9fe373e104b87891ad4327993a870f" => :high_sierra
  end

  depends_on :xcode => ["10.1", :build]

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
