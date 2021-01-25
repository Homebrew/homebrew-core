class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.47.10.tar.gz"
  sha256 "1d227b966d6c77972b55b59f88ab3d7859629a8c26f29c49f958c86168ee574b"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "304adfd624e647414d611c6bd67351b17842e496dd1efe9d70e315904a618b3d" => :big_sur
    sha256 "6c37b5f786958f3b2dc313749cc4e05f199a8aec7a8023b9449ce35df1cd165f" => :arm64_big_sur
    sha256 "4e430261db4146454a33dd5656fa3294bafe2bcd0626e8440b9e0c920a96b9e0" => :catalina
    sha256 "d09620d456ab1c508bc2b6e52d2425ff643aab6ac1fb99599a63a556fce03225" => :mojave
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
