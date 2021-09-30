class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.18.1.tar.gz"
  sha256 "6b12ea039462db0c585b17a153acbd2627b8bd41e6f7615e4c2f718ccc4c9b93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "17e1e84e6f7349b1bab42f14f8d7d1875154a6a9154ba709d27c12394969ce86"
    sha256 cellar: :any_skip_relocation, big_sur:       "ba3c7f10bbe57bde803cf3353dec300331e8e86eecc9a725b1101e08aa42e85d"
    sha256 cellar: :any_skip_relocation, catalina:      "fdcc5c1f0d49ef82f2e13950d6cb73f169ee1675059f13f6b4d2e30b613375dd"
    sha256 cellar: :any_skip_relocation, mojave:        "a2adc7c2e8bb6a9b29b6017bbcc5836edef626bcefbbf8f99c7459ed0b318c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95d55e44891dfd7ced8c9e1a86cda3925f433c5cf14801da5eea908e71d0caec"
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
