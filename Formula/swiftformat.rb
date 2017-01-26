class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.24.3.tar.gz"
  sha256 "0f1244223ac9ab1b1bbc5367e5a0c4877780e9eb6078dc01d6fcda6ac7e1d7c3"

  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "7a88c1e1c15b543b63a13d4bfbf408dcc9d04d81f6895be4d656f9a3d7751017" => :sierra
    sha256 "3ea7900e78acdf2ae9c9d274a79d8e33e64e8fa5f2650573e6379c0d91a43bb7" => :el_capitan
  end

  depends_on :xcode => ["8.0", :build]

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<-EOS.undent
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
