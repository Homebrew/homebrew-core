class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.40.8.tar.gz"
  sha256 "910e867c14716238f7395f679b9e2b3c108af37b1c0aafee43512d004fb19827"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "6368a3ed745a91fe323f79584a82328ffcf091a035132943bb605cc7a0f9fd04" => :mojave
    sha256 "28f1810cef1ccc3e11fbf2850eacf98b10dafa032991cdca904654fb9c7a27b1" => :high_sierra
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
