class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.35.1.tar.gz"
  sha256 "4cf422e382da12ba0ba255c661edd22b7af4bb71a45234376aac084d7b9ecafd"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "fc72a4dbeb0fba039935c3caed37a779129a86d5fd4ddb36e289cfc8e68a433c" => :high_sierra
    sha256 "d0eedff49dacf1cbbe48f7b611b434805dea9d8b68ea0aba8792b6ffddfe0e29" => :sierra
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
