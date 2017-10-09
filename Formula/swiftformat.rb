class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.29.7.tar.gz"
  sha256 "3e64ca315f5f03c49ebd14a690ccdf9bb461ed09827799722ed8be26e8ab23f4"

  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "d275fae6866e4e7042d4f41d9383f0fb64e40fa07a3da55e8a2a1a90cad7321d" => :high_sierra
    sha256 "9d14cbb4b194eb413425799c6b78b2ada1bc82fee7c4d51b4a6c048e1e60bb79" => :sierra
    sha256 "69174c57679a028af80d5c00b1a3b3da1e0898bd334bba72935a4aefb30027f3" => :el_capitan
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
