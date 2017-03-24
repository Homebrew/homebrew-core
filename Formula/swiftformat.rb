class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.28.0.tar.gz"
  sha256 "a7f7d348e0703a3822aae8b1da83250c8b9d4ccb83e347e891f4b555725dec0a"

  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "9b45eb4a25dd70ad9da2305e13ae20b21a65b8a3395ae0516a12a633e546526f" => :sierra
    sha256 "328e12b3a55cbf928892982c1c6176a7f264c237b6e8c27d0b8ab07256a9cfe2" => :el_capitan
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
