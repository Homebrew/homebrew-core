class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.31.1.tar.gz"
  sha256 "8fbe83ec4f4dcb5c157c5755978d00de6dfa2c9790c3788262f23c8d1b75350b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9327ef1f5d355d27b7e509f8d882a80675145f0c096b93697b0a795001e36a37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9305422435129fd091f7ffb3ea3a2f3fa77d0be9c2a78a815044227f98baa4f8"
    sha256 cellar: :any_skip_relocation, monterey:       "36b89c2a3e218f5e95864e4939d129bfeeeae3d836ceafcb8059425224bbdae4"
    sha256 cellar: :any_skip_relocation, big_sur:        "9aa781f8eb7772fe832af56a1d70ea83a0a265ec8733c695318baf959d701091"
    sha256 cellar: :any_skip_relocation, catalina:       "5c507ce54a61c0658e1cc82cbe4db297f92beac9cf3e9c3ff8e6b383f5b4634f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf12d434e34f66adc9200454b886e218404cda5889a1541fba1c7fe3b008ffc7"
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
