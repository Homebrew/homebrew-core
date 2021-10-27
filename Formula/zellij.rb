class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.19.0.tar.gz"
  sha256 "41cc2a6ee126907bf4b9499d41bccecaa28f631c46edaf140990e1ac2c85a4ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b65b8738a4f78733c8d4f8aa9d0be411e5f6b6a5be38637a214dd13931eb4e8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd47500097d7b82124edcb28c0ee8c75274a8c8dda16103856b61417da8b6437"
    sha256 cellar: :any_skip_relocation, monterey:       "de1fd138979a320d362c2b76f71ff36aaf61a6a7baa3a458385020e10d60c39d"
    sha256 cellar: :any_skip_relocation, big_sur:        "295361169d4b7d89bd7a6c461bf4b816cf6f19ee0d68d0e7b307a3b06603c81a"
    sha256 cellar: :any_skip_relocation, catalina:       "d97707e0f30b076069378d7fd840f43973d8a2e54387ce1a3065d2ceb44eb5e3"
    sha256 cellar: :any_skip_relocation, mojave:         "3d579e2b41625a1c2d77c005044a8406eebeefc0c570ab7231968c63b019c935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56879448c190de1ae1dd120237801ee90439398f366d2de5c02f415f9daf35b5"
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
