class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.3.1.tar.gz"
  sha256 "f97f9f39657602713af3ffd45f02e40145c7fdcfc4eecca1e289087318c4ab60"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "543c5918f2a6a647a1e2b2a304482f2688c1ca2825510f898f864c3eb93c7953"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32bc8ed026621fc0fd722f2414a64b0488b0b4f1eda23c5bfd6d8db63c4b84d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ee3e892b1cda859310cba25084dcb020fb7cfd6a3a21b8a67b05900ef80bbbb"
    sha256 cellar: :any_skip_relocation, ventura:       "e46171d00ce5477ebdeaf216970f99079ec669e15ab45b573dbe22fa23a28334"
    sha256                               x86_64_linux:  "30cb6939d5658722f0768ce58806cda33bea772c4c21e688636ae4c0c70d0b24"
  end

  # needs Swift tools version 5.9.0
  depends_on xcode: ["15.0", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcbeautify"
  end

  test do
    log = "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[MyApp] Compiling Main.storyboard",
      pipe_output("#{bin}/xcbeautify --disable-colored-output", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end
