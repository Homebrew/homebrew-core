class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.35.5.tar.gz"
  sha256 "1035ee8ab569e4e49617bc730d05a28e4d08162149001cf7a18ce9c482263f3e"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "f0015257a7281b9e543ffbb9db31290fe32b900220f5eda1e2b5eb2753736bd9" => :mojave
    sha256 "085ebb1b0e346c85e4efaa8c68319ad9ad80c8ace56673c35bccec41cc975519" => :high_sierra
    sha256 "3e4efeb33cb063b212eaa832362d024f601f6c00d797f3a8cbd6add86fbad131" => :sierra
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
