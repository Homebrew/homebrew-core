class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.12.0.tar.gz"
  sha256 "bf0be6fedc16d05db04c66cc91fdccb3b278cedf2bfa486d26d4c122436a40ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b33f70a025f3828edb8a3549fb65b4599be517b45b9c9dfb6b9c23ff9284990f"
    sha256 cellar: :any_skip_relocation, big_sur:       "37f4bab5d41a59a499c6a72a01af85047e405bfc1133a1de34e9d44205485088"
    sha256 cellar: :any_skip_relocation, catalina:      "4a60d0398b30516f5ed48d862337360a6f4302f7d329f1ef7e5c4baf38c7ea5d"
    sha256 cellar: :any_skip_relocation, mojave:        "a7756ce15390c54b3d98184777f0a398820930b29ad8404658c303c17c8b0384"
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
