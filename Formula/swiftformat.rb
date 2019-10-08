class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.40.12.tar.gz"
  sha256 "2ce84e9b6985235acb3225ab2a741c3a6e08917b92b7c769203d094dc6009b0b"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "1f8a6ee1e47e2a9c57121c3d36260c8c6bd26ca1131ce39569c7ee06e820b220" => :catalina
    sha256 "b301ef5bc8db74935d54c0b5165a45b1790e863ec29877236ae45644690c4587" => :mojave
    sha256 "ad421f264579919908d574cd50b1b82cba00f4eff9a36ae65d296fe4675f5f23" => :high_sierra
  end

  depends_on :xcode => ["9.3", :build]

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
