class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.12.1.tar.gz"
  sha256 "44ceb99d7c6efae17d172f88c1b98339723c5f9c44e342a2b77c59091bae169e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4e5aa1228e3cd47161d0c83262cc2b93d409f4505088ed7370acbfae27c786e2"
    sha256 cellar: :any_skip_relocation, big_sur:       "a1318976b46274a57a00775ca38defc1d970d34afe865d674eef055022064dbf"
    sha256 cellar: :any_skip_relocation, catalina:      "71fbb2b952e0dcf806dfb19a8ed02178c8e91ee63992422a21be7e67a3c104bb"
    sha256 cellar: :any_skip_relocation, mojave:        "2c0461881b6d8cc48dabe831fa620c4354dc92224e86a77099b98504ea0bc1d1"
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
