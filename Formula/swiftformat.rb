class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.30.1.tar.gz"
  sha256 "a0dac5a72ef0e5b485ddcbb20921d63e5638552b815010bcc869392a92fa5baf"

  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "4f752a436581207f835a90afe46ba319ab836681762ab37d3d5c7642e99526ba" => :high_sierra
    sha256 "f79686a3722c8844d7b9c4cb413d9f0a62e98ca7ed1664d5546719f84d448d76" => :sierra
    sha256 "903b2fa3e6002038654fec128f58578a32abe2fdce5a7230f72c831234fe001c" => :el_capitan
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
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
