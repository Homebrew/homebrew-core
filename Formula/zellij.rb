class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.15.0.tar.gz"
  sha256 "e8f3f190d75b89050ca7a85114ddb80aa8f03af66376452bbd5ed5c412a94e76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "08e16118424fe0b21538fd19486ec1c8e27cf69ef4f100373b7696b90dc5c55d"
    sha256 cellar: :any_skip_relocation, big_sur:       "4ee82bca930fcf51f290363466c590d4f1f7b596f6f45a39e132a3994f824cc0"
    sha256 cellar: :any_skip_relocation, catalina:      "0445bb8917a1a3f4853cbb441505a6b337d83230e9904a1b4864f31a0ecc8c89"
    sha256 cellar: :any_skip_relocation, mojave:        "cad649e3a7e036f926d7ea5a7fe949995100b99bc636931a9871d026729bd4ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58aa10c0563662a3a2c330442ca4a7948474a601999b881b0d6bad162a18ee08"
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
