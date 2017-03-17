class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.27.0.tar.gz"
  sha256 "d4a8ff807a5acf7a1c92045b793c06f83a5c273f8a7d77e838b49e40820f01a5"

  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "5ba484a3e61782979f438933c75bae7f5e2953dc32ad2c24c6130c3aa597fc1a" => :sierra
    sha256 "17018681fec4a6686633ee48bbe44e88e9054d3fff0e0d6d0db45bcbc1dc78fa" => :el_capitan
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
