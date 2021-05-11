class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.22.tar.gz"
  sha256 "601cb0126284b09c85f1a03f5d08e785391b3fa824ed9b436678ee9e7e695a25"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dfc76b5caa4fd1760bf8d0f54958551bbd917ed2fa8c248b4ee06000520de10e"
    sha256 cellar: :any_skip_relocation, big_sur:       "dff40a35f881f6b4deafae05e14cc11c0c34ee5326859a0117b19a1eea2e1b36"
    sha256 cellar: :any_skip_relocation, catalina:      "9cd6cb2214bb291d439f78608788c037a252fd8c7213b2c194a9b9cf15dad4a5"
    sha256 cellar: :any_skip_relocation, mojave:        "8e509b6c8be927233cf80b46ea705d84fca9bd81a9db73c986e472d4a4b16bc0"
  end

  depends_on "pandoc" => :build unless Hardware::CPU.arm?
  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    unless Hardware::CPU.arm?
      args = %w[
        --standalone
        --to=man
      ]
      system "pandoc", *args, "docs/taskwarrior-tui.1.md", "-o", "taskwarrior-tui.1"
      man1.install "taskwarrior-tui.1"
    end
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
