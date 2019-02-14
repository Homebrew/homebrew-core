class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.39.1.tar.gz"
  sha256 "583e1db5cf78b930b67d6d01622da55545873bb947a02d2ecaa79a386cbaab23"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "4c756666bd5a8608336706d69b2e17cb23bc7916708f0979a1ca9a18cb28f892" => :mojave
    sha256 "9b42ef468f88dd4366d1656f84e3860311435204b524f77566b42aa8c4dc56e4" => :high_sierra
    sha256 "3339febed8ccdae4fc1a6592f987f3f4bd9bf4f91100f3b51aeba63b41b2e62a" => :sierra
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
