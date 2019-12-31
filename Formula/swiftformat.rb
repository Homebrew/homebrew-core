class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.43.3.tar.gz"
  sha256 "a14a1d67a8d7fcfb4454f080a6e21797435a6555d052a64336f204cc3b41cebb"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "58fe090645ec8bd7ddf4c9f893b9cbf5e6585c8e801c5f2ba631acd8491c9f72" => :catalina
    sha256 "b4f9579e54c5856c1cb4880d5e091b29589d94b30a832ff93399cb40e5269263" => :mojave
    sha256 "f5bc479c74da9b3c0bfcde6d9e1dcc24d5c5a08b9d6bd61ea21a066951351cb4" => :high_sierra
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
