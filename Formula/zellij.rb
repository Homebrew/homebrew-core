class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.18.1.tar.gz"
  sha256 "6b12ea039462db0c585b17a153acbd2627b8bd41e6f7615e4c2f718ccc4c9b93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ffcefef361baf3ff64e3e7886b06651bf3a61ab7a3cb3c8f5defcc811893632d"
    sha256 cellar: :any_skip_relocation, big_sur:       "8ad1b08cd95fa7c1d2b919ef4b0acc8789e7f6f6ce1cbea5909dc059a2681a70"
    sha256 cellar: :any_skip_relocation, catalina:      "7e3ffa9ee3535ad5936a16385ff6b16f6fe9539f77b663f8953a1d319a312d3b"
    sha256 cellar: :any_skip_relocation, mojave:        "d67154fc065bf0b2053edf8f3e35b867a26293848ebe19954bb223b9ab991586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7f929541e8d238e703be5ae40715179929cc3a15938a87d2b30c8ac9e750eb3"
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
