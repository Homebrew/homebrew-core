class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.27.0.tar.gz"
  sha256 "6159482c25d3cb55b04d23230812f4450e88ff0975161594297a7deef8979a38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1dd7a49eefdca2c59acd2a387513f84ad6c2949a9f2dba9eb366aafc142b7e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b701b71a1bc4e04832a860960987826da3658b43b538a05e8752e802c4f1f225"
    sha256 cellar: :any_skip_relocation, monterey:       "20d843c612cf763186e9924e840f014f44c5f82cdaa2f2fa3c1a9035e7c6d425"
    sha256 cellar: :any_skip_relocation, big_sur:        "83717ff84de4e871c00cb2cbba092eaf3df3ac720d01a1d8ac39562e38e4a6bf"
    sha256 cellar: :any_skip_relocation, catalina:       "c983dc86f8ec09378c1832208200c4269bd67f56e931f6042f318337f34fcfd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d76637586c500fc412c114fcbd70de8ffd21cf6fe48432ac84e7b09732f1a954"
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
