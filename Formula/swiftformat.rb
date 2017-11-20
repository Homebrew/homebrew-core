class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.30.2.tar.gz"
  sha256 "aac89f3f66b0a8f9ca683e368a2df29b1f45012c3bfb1a5523adb94e45e526aa"

  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "4823832631fbcbca9e01ba0dec73fe69e7327b35d58569e44d1b53b78ed0cf81" => :high_sierra
    sha256 "244df621f0672d1a2b48db33972b00c96a411d94b8b94e9e84ef615642a2b9e7" => :sierra
    sha256 "76984598c5f080202bf53e59b27f8b45b27f0ed7caa1a70e82089c24e811f017" => :el_capitan
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
