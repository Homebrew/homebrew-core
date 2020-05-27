class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.11.tar.gz"
  sha256 "38556e9d4d7c6d4f384964d06bb76e7401d75c10452111ae2e8f925a8a5ddaa2"
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
