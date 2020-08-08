class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.45.4.tar.gz"
  sha256 "83cdf557b8b415a78d85ea6f797861fb720c6aa837527cb08ef55e1f8f5908cb"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "3a4155dfd7ea601e518751b24c2ee21aab50a865e4ecf346a550f6c55fce1dbc" => :catalina
    sha256 "f1159ae43fae2c6f3c420376351830947253219e75bbdb2475839438ad67355a" => :mojave
    sha256 "032c680cc0d60115529f4e35b8ea10758c37adfc9bc433418a64b8531b431082" => :high_sierra
  end

  depends_on xcode: ["10.1", :build]

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
