class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.30.0.tar.gz"
  sha256 "52253271dd954e2705571a9bf2b2f7873fe47e0e5b7a2e85aac1b1c73152914c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5da916ce5e53665e850e1e5d1bbb0c709d84cc452ae7e7b1cd81a964bef24ae7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e28f57659a5223e1c4635936d0ace2e5dcaf10f3c90523369711460089483b85"
    sha256 cellar: :any_skip_relocation, monterey:       "60600cb7513c08cd1930de0d87b70d6ed716a782bee5998325b35f4f60d71db6"
    sha256 cellar: :any_skip_relocation, big_sur:        "31a10e509e1481ee343129d4d9304b24e5c8d9a8727870cd0d3381577e37e14b"
    sha256 cellar: :any_skip_relocation, catalina:       "f4ba713e9d384d851dad317156bfa6b6f01d9d0ee77101c36f768528763ddb22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2594fc3d056cd1092ae96912a2410ea3d2a4aebfae695282490122fe953064a7"
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
