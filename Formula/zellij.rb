class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "850d1a68219debdb4e05f7f58e70b31f440425247caaa1b29b9be1b6c7869207"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    (bash_completion/"zellij").write Utils.safe_popen_read("#{bin}/zellij", "generate-completion", "bash")
    (zsh_completion/"_zellij").write Utils.safe_popen_read("#{bin}/zellij", "generate-completion", "zsh")
    (fish_completion/"zellij.fish").write Utils.safe_popen_read("#{bin}/zellij", "generate-completion", "fish")
  end

  test do
    assert_match(/keybinds:.*/, shell_output("#{bin}/zellij setup --dump-config", 1))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
