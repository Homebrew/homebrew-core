class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify.git",
      tag:      "2.0.1",
      revision: "3140aa2d58063dbe30426cce118f8ba8feb37e60"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1214dd4c5918fe702710ad5a7966239a9102d0d4add685bae3eff71a6c901576"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbcd950c6e9b581a4840efd703977adffee5f8bbf4c626e29ada9f5396217620"
    sha256 cellar: :any_skip_relocation, sonoma:        "980bdf18ca7e57ad1c0f6ab5ba632370db94e29b9eefcab82904de580e15d5d3"
    sha256 cellar: :any_skip_relocation, ventura:       "e59fd6d042abb621bd60f88a1cd6fb7a3a8833cdaa28f8773c4888393706305e"
    sha256                               x86_64_linux:  "c16e3098d644c3fee4af2646a11d0567b335d5237334ce58d8f1aee86a18a32b"
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
