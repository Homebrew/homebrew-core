class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.16.tar.gz"
  sha256 "35cf41e636755c8e577b15429d36ee5f75a52ac4cfc3159dfa766621e438e38c"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "e03e40dbe228ee7136cc2dd57079b589a6c531f4f2a52fce8a0ad7aaa2e2a935" => :catalina
    sha256 "9b866de2516e8f68b1ad764f996f38cba31b2d2fc345ba683bdd1867e6a44091" => :mojave
    sha256 "eb111096afada9821c4cf1489706b5daf599670d8651719955998f763c6b9cdb" => :high_sierra
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
