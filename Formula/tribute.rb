class Tribute < Formula
  desc "Command-line tool for tracking Swift project licenses"
  homepage "https://github.com/nicklockwood/Tribute"
  url "https://github.com/nicklockwood/Tribute/archive/0.3.1.tar.gz"
  sha256 "8c3b04d4222fee8b1d76d857d0af9aa6738b1ee123fbeffd104206f647024531"
  license "MIT"
  head "https://github.com/nicklockwood/Tribute.git", branch: "master"

  depends_on xcode: ["10.1", :build]
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
               "-project", "Tribute.xcodeproj",
               "-scheme", "Tribute",
               "-configuration", "Release",
               "CODE_SIGN_IDENTITY=",
               "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/tribute"
  end

  test do
    (testpath/"Foo/LICENSE").write <<~EOS
      The MIT License
    EOS
    assert_match(%r{Foo\s+MIT\s+/Foo/LICENSE}, shell_output("#{bin}/tribute list").strip)
  end
end
