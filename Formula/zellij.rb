class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.22.0.tar.gz"
  sha256 "817b21bf8c7788e54a05fe6a16094d2205fac5b79ac98073319df3088ba55fd5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bbf014771c6a5ecc5d6e569c84427077eeb21b63a3f25cda6b72fb593f88a0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd4ea8147e939f942d91fd5632239fcd02e83e1e99d1428bad793cb66504fe73"
    sha256 cellar: :any_skip_relocation, monterey:       "e850b4c8f86efc39bbbd14d79189bc4fcea1c4ff2888dfff7f3dcf3d45642da5"
    sha256 cellar: :any_skip_relocation, big_sur:        "90ef5e81eee2e7d63c9973593729f140afc19b81cc5ee8c79766970c7b784db4"
    sha256 cellar: :any_skip_relocation, catalina:       "ce8018bee3b5d0251857e9906e0f0c2cbaf07c533255522fda4363624c1ea383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b8fd41fcba28b0f08b70faf3cd54a4815d881e14dca6d9f7b2a0437f3f9d5d7"
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
