class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.26.0.tar.gz"
  sha256 "f0b0cfe7b72ce842de80d5c32cc2abe624b3286fab16f313a4e43e226e95e87b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff39d321862e0b393e0849c2671c883ac34cf86c806906f01667a5cce9da0d5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04e32d5d3f8eb52051e48448efcf43981b251bf75a29571ae6dd6dab79f46901"
    sha256 cellar: :any_skip_relocation, monterey:       "25551abac0b7b545a3cf84bf4a6b9f6f5b9f4169f8dab83f38134e9e2fdcdc55"
    sha256 cellar: :any_skip_relocation, big_sur:        "babd165907eb3bc6fe71ac3f2e390fbdf51869b12905c08cecfae6aea39542da"
    sha256 cellar: :any_skip_relocation, catalina:       "63dc077a7513e5e3642a4808425766377e4f8eadd0ae2f4e84a759e6defd772c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdb1aa284f7e03889a09d170cadf41151f28e10971a8c96ed4bbf514e8d6bef1"
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
