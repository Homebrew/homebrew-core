class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.41.1.tar.gz"
  sha256 "05511724c5a232cde0ebefeda6cbb511677c8548fa2b3d568473a7ad9a81e780"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "c5966870e330135b348b3d408df9ceb7813ef70bac3613d7e65fb96351d663c9" => :catalina
    sha256 "176c45965ff6ce06b1b5a003ee138c899a6980e6e48157f221a53e1a59d3df94" => :mojave
    sha256 "a440e70e6cc5674ecbc53405dffb029af4fe40f02df8a72cd6f2a1e594df7104" => :high_sierra
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
