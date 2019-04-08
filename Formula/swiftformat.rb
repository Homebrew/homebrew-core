class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.40.5.tar.gz"
  sha256 "dc9bb60e17968be63686f6f3e88c853e28192a8e5256d3966716d73bc7224145"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "326ec4b1529f6391f4345f8b4433c4c3ead5387b8c5fa4a049cc02ab9ca08bb3" => :mojave
    sha256 "2dc5a21f5c03495c8213772d0bb9f5bbb070541c4f93336210ed9bf3ab03cee7" => :high_sierra
    sha256 "7f64594c19fbee10f7fa52360ae124acdec3095442b90967f5b2955206cb0e4f" => :sierra
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
