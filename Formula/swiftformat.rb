class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.9.tar.gz"
  sha256 "6c39c266f5fc177ca135e73dcf090dd14f800d4f95d2af98ee7724faf46b4390"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "9cbd2c21d4579c8c4ffc9df7b44593f7622d13f8517a3fed047c5e5f3f2560c6" => :catalina
    sha256 "a8f8b6fa977804c2d13f0cbc9ed223ddaa88e3c0684e91519e005784c8418b36" => :mojave
    sha256 "fd43d192d194a8bb02308714b691e6a7101f839889f749dff4a1facf8172b951" => :high_sierra
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
