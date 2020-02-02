class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.2.tar.gz"
  sha256 "dcefe2c1a9a62e521a1692b840dac7693ec89ffa7c3d76496466288be8c1ff0a"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "95cec024e6ace171b3a7ea88487ed7cb614e3d7db7cf47cbdd8e4875888f7485" => :catalina
    sha256 "635691a03bd533c59c42b8b9e11af652d2c582179098ff422df409fff5c5d96d" => :mojave
    sha256 "15c494f50d4b770451b4205fc17e477a74300252df72dd0520c94f49d8e012af" => :high_sierra
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
