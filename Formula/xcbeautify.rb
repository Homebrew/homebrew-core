class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/thii/xcbeautify"
  url "https://github.com/thii/xcbeautify.git",
      tag:      "0.9.1",
      revision: "21c64495bb3eb9a46ecc9b5eea056d06383eb17c"
  license "MIT"
  head "https://github.com/thii/xcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5572f364b24076c89fe78d7128d8abb198a5041561b7dab0312c2050e3390624"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07f7226da16337b9947871edf3e6112e042d9371872eea692877cd83e3f4e18c"
    sha256 cellar: :any_skip_relocation, monterey:       "6b181df5d9351b281176906c09009e991b014baf16f0f88d4680012d7715a52d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b95942893695e6ea3d30c17064939161f6e573243cc92035e930b4e1a39deef"
    sha256 cellar: :any_skip_relocation, catalina:       "5b053728e2ee73f3542cf2b7178af1a5d309970f5374fd1342da93e6dfcb57af"
  end

  depends_on xcode: ["11.4", :build]

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcbeautify"
  end

  test do
    log = "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[\u{1B}[36mMyApp\u{1B}[0m] \u{1B}[1mCompiling\u{1B}[0m Main.storyboard",
      pipe_output("#{bin}/xcbeautify", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end
