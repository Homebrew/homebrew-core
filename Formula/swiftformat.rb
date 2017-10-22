class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.29.9.tar.gz"
  sha256 "f60fb012c531811a7447c49de70c4cb1c9d6e054f42e4533755c4405217f2111"

  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "025c1fb27e591371510e519b6a7483e821767a9676bcf0a1460af8ea2e28f75b" => :high_sierra
    sha256 "57e5439c058c44ed809aab9e202f0042b0ca220446455e0df36b2896c4aa98ae" => :sierra
    sha256 "0c5147ff0e6011ed5bfd603b5b5e81be6c879976c558865da7b55b17e917672f" => :el_capitan
  end

  depends_on :xcode => ["8.0", :build]

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
