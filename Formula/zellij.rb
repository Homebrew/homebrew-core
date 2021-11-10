class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.20.1.tar.gz"
  sha256 "aa2cc622f924c1d41a8b1b616aae3d7b989e483bca1041061db43b6d0c6c9f52"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71b39bc4d51ff336078286eabaca331dd2b5271236bd143d518a6d70c14d0299"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "258d698f9108559f316f03f5a9c43dd0cd9b4d4b02f62992b67f9d4a08b945b2"
    sha256 cellar: :any_skip_relocation, monterey:       "254c86d3646ff1dbb6340567d14b4ea0e206978a31f2a674116137ff0972175c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fa639ee92727c4690a482beddafd5665ae87eb2363e5a1d6389351fb01e58d5"
    sha256 cellar: :any_skip_relocation, catalina:       "02dcafbadaa534099d40007849faa659e95b623899e0f9809e96a38c58536c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d68067e80dc17644de8595f877b81ab45441c1c588aeacbe0d7fe4f1381a3434"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read(bin/"zellij", "setup", "--generate-completion", "bash")
    (bash_completion/"zellij").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"zellij", "setup", "--generate-completion", "zsh")
    (zsh_completion/"_zellij").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"zellij", "setup", "--generate-completion", "fish")
    (fish_completion/"zellij.fish").write fish_output
  end

  test do
    assert_match(/keybinds:.*/, shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
