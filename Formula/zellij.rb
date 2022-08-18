class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.31.3.tar.gz"
  sha256 "61949cc0c44b11082e6a4347d50910c576b1f131daa054a17ed153a6fd0e8b20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c7886eb7c81022d5dfd3d2c3e8ef4db84fedf3ef55c74e416c1e85bcf1e6732"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a00a838c0a0f0cdd113d3dd96a6d99ca0b106e084222647d350f218b2e2084d1"
    sha256 cellar: :any_skip_relocation, monterey:       "ee0914edf58ec99cced4ae0c11ac893ec5ccf1e126b6d725dc93ce2db0ed6b01"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e406e4c581df41517d91149f0f08fbe53ad520511092f015ce25e1cb5c862fe"
    sha256 cellar: :any_skip_relocation, catalina:       "94c6e36b6713bd4fded8c59edd40411ad2e7abf1cc1a268b114ad63c96b07907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b26f7bc4d20cc611357d11fdce25c980567bbd8997c7ae9cc1c71ce9226ffaa6"
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
