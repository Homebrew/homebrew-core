class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.33.10.tar.gz"
  sha256 "395beae4ef703bd4156dcf1dc83dc8b496ca26c42939eca6a78403882dc7bdfe"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "e9c4c7554a4db70077df9c8af1976d48d13aefde61c09bd0fccc1ee316d65ac4" => :high_sierra
    sha256 "5c4a3ba5fa60927bdefa5d07065a1c004de2c0e1b98600389aea77feaee0e3a4" => :sierra
  end

  depends_on :xcode => ["9.0", :build]

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
