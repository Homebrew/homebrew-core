class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/tuist/xcbeautify"
  url "https://github.com/tuist/xcbeautify.git",
      tag:      "1.2.0",
      revision: "bd7d6c429e8137a60426154fc517a0cb2fda2159"
  license "MIT"
  head "https://github.com/tuist/xcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa5bc88f4c2fa325cc8960afbd3593692dd05357808ab23cf75322f8a116cc1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35ffe5cf4bcb2d2a04958ff4ccef5262addf517e8085155476946402eccc34f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf20740220523ed8d1e60f9c918c78dd73d2eb6ae4cb3ef906687af44c8c1a92"
    sha256 cellar: :any_skip_relocation, sonoma:         "2dcc30f24d43eee4fdf98a4d6ae9513951f00e1fb1738cdcae746b61f03c9972"
    sha256 cellar: :any_skip_relocation, ventura:        "a1f0460ba85d5a0e55edb0d116aea7bd52ccca1c21f4ec7dd6a7f7ab3b5f696e"
    sha256 cellar: :any_skip_relocation, monterey:       "31c54053550f88a56cc0ac82c3d59d3d56789ace83deab5dd1606689f88fd728"
    sha256                               x86_64_linux:   "012d8f74cf52df29fdc81d7256d9db3a65a37666790322a77be1eadde060e74f"
  end

  # needs Swift tools version 5.7.0
  depends_on xcode: ["14.0", :build]

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
