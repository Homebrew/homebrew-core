class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.15.tar.gz"
  sha256 "e4a4f1a781fc623af8d76848c2cd59c4b93a909df74ccd30396537f1230c3f01"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "603d427a858e083b6991e109cb6ae77f9ef4b691b256af6861bbbe59df1fa3f3" => :catalina
    sha256 "f14121fd134c71e989154f19bebd4e36dfced9deb479030741357cb51730a237" => :mojave
    sha256 "28a68db09910540790cfcf63271d1f5ab86c12453cbbde8f25915ce4bfa29930" => :high_sierra
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
