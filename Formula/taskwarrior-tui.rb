class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.29.tar.gz"
  sha256 "999a166f51c6ba596627725799fe6eb9de34360aee2d18a637f22f45a9efd2a3"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1daf32f0e092899d18a5152cca742d0844bfb163353e67575bcb7e16e111b5e2"
    sha256 cellar: :any_skip_relocation, big_sur:       "fdc1180037f29aebc6c89685e115970dfaf5c3167af67daebc28948090639083"
    sha256 cellar: :any_skip_relocation, catalina:      "6f1d3f49817f312f9f6dfea31dce6b1a74295d3a7655286c2ad233775214d32c"
    sha256 cellar: :any_skip_relocation, mojave:        "54eeaa73357ed81f4c021301b4b4610eafaa0cf9f59b37628a471e484f580f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cd0d3c082a96dbabd0d34503ecb5eb46abd43a106fde52ca9d44d2140513757"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args

    args = %w[
      --standalone
      --to=man
    ]
    system "pandoc", *args, "docs/taskwarrior-tui.1.md", "-o", "taskwarrior-tui.1"
    man1.install "taskwarrior-tui.1"

    bash_completion.install "completions/taskwarrior-tui.bash"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--config <FILE>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --config 2>&1", 2)
  end
end
