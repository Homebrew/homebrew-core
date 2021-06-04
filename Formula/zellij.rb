class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.13.0.tar.gz"
  sha256 "5439561d8d7fb51d0f9bd1f3d5a0caa79ffc7dffd1c910adc7c56841df2cfb6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2aa26eb54805571ee3d1e5e4a9e160f8c42a90ac9d013a04ae1bfd306534d554"
    sha256 cellar: :any_skip_relocation, big_sur:       "b84aec6ae0fde316ddf8fb6d49eb0f1bf17f9780d83ad3ee282ed984c87be6e2"
    sha256 cellar: :any_skip_relocation, catalina:      "a89f9f37cba89eb403ba6762a0eecf781bee3691bc2797a84562afe80364bbda"
    sha256 cellar: :any_skip_relocation, mojave:        "2815dc5e109a37a9ac6c30e2c050663c95b23adc204281e12775277613ce4611"
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
