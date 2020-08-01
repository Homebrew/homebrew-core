class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.45.2.tar.gz"
  sha256 "c3c07ffdba8f172e84848a5615a5c20741c5d199dfbc685f0bafa9307b827e91"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "ffef6652d86afbc7a686ade2785ca1c3187e435b5326b66f85853e4e0bbc5a8b" => :catalina
    sha256 "de00c3bb9478ee614052c8f45ab70696a224414e8d8736ca1e731eee0850603a" => :mojave
    sha256 "41f489deef8025ae856d1f7ef9f05c4cce953077b54249f76ff3e6f204e10b1c" => :high_sierra
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
