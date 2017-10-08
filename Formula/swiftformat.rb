class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.29.7.tar.gz"
  sha256 "3e64ca315f5f03c49ebd14a690ccdf9bb461ed09827799722ed8be26e8ab23f4"

  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "1738b4bc2b7325a3e3e1cf8703755717c24eb8ca691d55ec152376bbc15d65f8" => :high_sierra
    sha256 "e466ee7ff2fd7a71db2cd9952818b83b2ec1576fa1f2c069d93c7de1e51cc8dc" => :sierra
    sha256 "1c9c9628f2461ae8d4f2eca8b3392f5ed9df1ca286ca2715ca8e56c6bc3ce249" => :el_capitan
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
    (testpath/"potato.swift").write <<-EOS.undent
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
