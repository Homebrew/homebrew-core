class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.41.2.tar.gz"
  sha256 "50514ba39cb6bd8a206f3d88032fe4491d02bd5cdad9ffa7077b59bcb30a7ce2"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "8b87c94b4ad063ade84d705fffbc2d0869f9f5950b3c1059eb677f39a4cb4775" => :catalina
    sha256 "315f573dd4fb03e66a572861362942fcfec57080aa0fcb0e4f2755be2a0bed2a" => :mojave
    sha256 "293cf2cca5500fa928acd70a226b8f9933a5a4f6825a8598ecb88edded53cda0" => :high_sierra
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
