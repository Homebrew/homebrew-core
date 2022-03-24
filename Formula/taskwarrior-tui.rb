class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.22.0.tar.gz"
  sha256 "72a844fa4f9d141ccf3a9a1e5a45795fa75a84ea89ed42891ddfc296f7b6eec3"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "560f4d9378c6a0d8bd6de37a216e1c5d85974a04ae987e7d0b6d563a41dcf6ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61a40fc38478c44c86506f7e102cb2547f3416455ec45eace202042577d27942"
    sha256 cellar: :any_skip_relocation, monterey:       "fa928463b0f1486241020634911cb1c576882ce663b61108a503e61796d7bbb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0572a1baebfd082639a13351ed2e0386e2183c039d0b62e10b964162bce32335"
    sha256 cellar: :any_skip_relocation, catalina:       "c90b32cc352a7811c074affc907a2378c29b120fafbf76256f7e524c234b8b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4df8cf393e979bc6f56a31cce505aac3c135aaf0462076ae351bd4d28d26da96"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/taskwarrior-tui.1"
    bash_completion.install "completions/taskwarrior-tui.bash"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--report <STRING>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end
