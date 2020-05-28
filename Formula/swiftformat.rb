class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.12.tar.gz"
  sha256 "eb01891b10c5f2946696635566d45e2494ff35e56bee2023e2d741f00a6f8974"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "562fd36b013cee11a7987a84bbd2ec2cde1bb895c82f2ca35a24bd761ea46c57" => :catalina
    sha256 "3b92d4016f89bda4f371bb579aa53dd734c8c24cca50ff83edfaec499f0a5824" => :mojave
    sha256 "1da4671636eefb8951b2919c722f7e5974f0f0cfb136e4905ed1d1cc6e8113f8" => :high_sierra
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
