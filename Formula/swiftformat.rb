class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.11.tar.gz"
  sha256 "38556e9d4d7c6d4f384964d06bb76e7401d75c10452111ae2e8f925a8a5ddaa2"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "2c64a5a79d32d477a9e5f9bc2720d36c64541d527edea47c7b8dc48111d5f356" => :catalina
    sha256 "e1f2a970e8ab85e0cb3c8f90b512b3dd4e27c928ba2fdecd66a17d105dccc6c3" => :mojave
    sha256 "e08586cbbf484269065eb74c2a79674498799ceb1b1c3f34d30492946d5b5efd" => :high_sierra
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
