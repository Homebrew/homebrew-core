class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.3.tar.gz"
  sha256 "5249438143fa240f16d218727e30476739eddad048fef749103e72b928859929"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "bf4e73e35b35f6bbaedd0009a26781634c2c22a145de80adf3c69e9caf8fcc6d" => :catalina
    sha256 "1b17615950195914196f9c91259a6ae90d15e0b6cbba30f238ef6bd47078ce91" => :mojave
    sha256 "bc9e8cdf3c1b9a2295d75b065f1b8be81725a95fdbed7869e5ff56a8c02c36da" => :high_sierra
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
