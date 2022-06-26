class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.30.0.tar.gz"
  sha256 "52253271dd954e2705571a9bf2b2f7873fe47e0e5b7a2e85aac1b1c73152914c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c94049a7bc59ab57572897acb29b719c9db2c5cc8fdebfcc9163947aa5acb84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "070037ad136a886d950984a6fccecd14433b0d14f271eda0d9bfe663b6fedcf3"
    sha256 cellar: :any_skip_relocation, monterey:       "afa34400b29097ac0ddfab25a8833f00fea74b12b9a0bec6e43772e1795709ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "922ea349885b2f3c745744836f2e4548c8a35f8e48e19a0adda35d8b0f82e9fc"
    sha256 cellar: :any_skip_relocation, catalina:       "b7311e0f5a0b15627b457b3362d1ac8a0b278d5343f5345d8159130135bea4f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3c5e07c8fbdd63f36c7a98784ec2c1ff719e215e08d8b0f62688f1a036db6d9"
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
