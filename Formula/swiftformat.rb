class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.45.1.tar.gz"
  sha256 "094470fca585275bbc87007c9adfd636a1d65be46ac45420e02486d54e6ecce3"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "259abd937a6bf2ff78114f06bf2f321fc75f15710e7767e71bdc9ba2470634de" => :catalina
    sha256 "bb8fc8055d5a98ec0b1a2e771b9db63503ae0b5bde13dee6ec7e782a61bcc1ca" => :mojave
    sha256 "68a984ecea8933c41fec893463772efe6c1ab46248b60544e60eecfe6ae4dc26" => :high_sierra
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
