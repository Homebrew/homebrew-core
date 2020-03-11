class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.5.tar.gz"
  sha256 "aa5e83fd345b8840f27c9d332c18af4607f6ee53be307a6f40269dedd1f92e58"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "bae6a0074290aa2aee3819cb1511f362e0058c5c17b9c5ba254505b108f83f3d" => :catalina
    sha256 "817e6732760b0dae85cb955418a6b428a7bfd6e0f91d1c5668fdf997e6bc4199" => :mojave
    sha256 "68efd5f5c175e1248295542c7a03fd3605cbedc53c85116db155fca6efce006f" => :high_sierra
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
