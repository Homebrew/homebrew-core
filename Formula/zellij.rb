class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.20.1.tar.gz"
  sha256 "aa2cc622f924c1d41a8b1b616aae3d7b989e483bca1041061db43b6d0c6c9f52"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dba9049b26129a614e5adf80f8d8dad7d0b101f0ff961649d56bea1c03bff20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c66fa96c834ff76f5a5c382935ca79df8db8c6e144d42bca0acecea52ab49c91"
    sha256 cellar: :any_skip_relocation, monterey:       "c16070aa9b2359b771ba579c11a7b57a63f12899b2fc2205f5a782892856bded"
    sha256 cellar: :any_skip_relocation, big_sur:        "58efeed4d6b91f7b1347fc353a3b9f7fed9af070656043e8fb1150f143bcd29c"
    sha256 cellar: :any_skip_relocation, catalina:       "5d4714e75de430852096c421e8da1cb4be6b174036a8763e1a413d35d282af47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63e0827224a9bc21c213246dd2d4fa0cb003a1f2465c561ba3fd90b91cc26c76"
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
