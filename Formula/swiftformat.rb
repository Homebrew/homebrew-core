class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.43.5.tar.gz"
  sha256 "a5915be8e4bba5f3fd0a7b49bb0c03ec88f1c2760ddfb32af4e5fd89c65c7ba8"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "3efcdd1a669fa6cb1b3c5ec519a8caa3c3f91f748f28f2ba0f20a4035a686031" => :catalina
    sha256 "5b634290c2efa4337527051c5ab86be1bdefd81d86faacc9bc80544be77e1695" => :mojave
    sha256 "4a8dc613e8b89d926abdd2a5c33b5ccfcd0e1320d37bd81515d4086cf98cc37c" => :high_sierra
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
