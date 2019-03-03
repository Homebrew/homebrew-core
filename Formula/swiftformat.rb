class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.39.4.tar.gz"
  sha256 "c86f4b78e46911a9e0cfd2b82e6389953ecaeff9bfb8f4eaee4d52fae93df112"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "d795cecbff5b506ff80ccbe01db339eb8bbf3930c5fb93d8016bbe4aec604aa3" => :mojave
    sha256 "caf8438daeff3e045bf0605be0ee2db677025ace7ecbdddbd078fad58d0a55ff" => :high_sierra
    sha256 "74c89b992b8cfec9917b0ffa3a723c0fa0f778b7b3b7f4572534541f4aa9fa27" => :sierra
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
