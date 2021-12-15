class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.22.1.tar.gz"
  sha256 "8d71fc7fbca1f89e4a20b87f4e149ee4a97644b7d4807201c50cd9178a0feb57"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e33ee71dec05c496cfdb5af8c1413d3d1036d0a3b8e2bb0db5d2609cf0f540e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf0a065d29b1a7de8fb00a44b65c834f71159c9964e20e074188324c436dae25"
    sha256 cellar: :any_skip_relocation, monterey:       "30847614e7aa988b7d85187163bf75c1eecd6bd0caa6ce1b218737b832bbd3ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "39f5444484260b7a6eac8d0a2a6af5a56c018f26ecccc6b7774654c78e2cb0d1"
    sha256 cellar: :any_skip_relocation, catalina:       "7b048482db0a4be548e426a776e8f0be7c3cc98ec01f7bc45cea41e9d718a062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26174ddb8189de044d53f293d67e8d7f0887d7e217031be0ad6cf196255fb3d9"
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
