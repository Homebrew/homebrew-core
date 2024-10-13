class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.11.0.tar.gz"
  sha256 "a64c0bfe9dfb384305e68f043bdda787251dd251e7f40719f7ac997788d0b236"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f41d8a052f642e6b1e1edede3dcf42bd0f1a349a3660c05e8876a4267f44910"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "697d50f9544c2daa242d7787e43fda4460ece2c3440cd7b9baff4ba051fbaa6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f58c2e7342577a7b274bf5be5a9c0915aa3f3ba5b4a05674c6417c8d03637cfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "629341e7c0add869ed6ec0d3a78d6f69e2e53ccf765296981be5677da789df6c"
    sha256 cellar: :any_skip_relocation, ventura:       "bb72929872a1b86e7e9ae523e87a738d940667f482d45cfdf7d8888ffc0efc3a"
    sha256                               x86_64_linux:  "e9d0709beee07adcc9be5137fcb117191c6d908817223ea9bbcd427127f3e642"
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
