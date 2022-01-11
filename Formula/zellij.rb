class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.24.0.tar.gz"
  sha256 "a7f2d1fa1dd9c55d37d1daebdf6af3c6666d144ee1e85ac7f805544ae03e3b1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0cfaf62260bbfb704a31f86dd5cb93c57ae8bd54bb100c43dfb5bcf164f103b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4476a2e8e734910fb3d0ed665501c859e0766c9f2a34681ac36669738b1c8fd8"
    sha256 cellar: :any_skip_relocation, monterey:       "dab95745d7d4a85b87c34a6ce59a0a8305bc515c0bce1c949cad649a39fe0c8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2dbe345a9073a2a88fb333e9c8c87bc76fbe61142cb954ffaec517a7196b70e4"
    sha256 cellar: :any_skip_relocation, catalina:       "8c583e47aa51c2c118b26b4c7104e6b6b5ba2b8b58448ccad973cd3f5d347e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d527a7628a4862af39faf8f6faa4fe57440021a75fd1212ae015785833f70bc"
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
