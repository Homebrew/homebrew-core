class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.26.1.tar.gz"
  sha256 "3770c57b09ddf448eb3a873e06acd3dea4ba420f35e41ac2d5a5ecb2f3cae15c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5ea6a64e5eaab8e8fa5acdc89e089bb34ad0d61e8cdc285a80daba40a24d3b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11a38b412e970a02491d23d536e373ff2394cd8806da058f0a72e04c439cc483"
    sha256 cellar: :any_skip_relocation, monterey:       "6baf5cb9f54f226ae824cb6c73a5e2ca4e793d494b32a4e780fd43e332d40935"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c5c2146746ff597013338e99db77cd6ce6d056b8659c20aa9eb2f120ed2e822"
    sha256 cellar: :any_skip_relocation, catalina:       "994234f39ad15aece09d1c6a57ed8bc4d5672347b321b2c1db30074d0f2f7dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ed3780b7dfca905d3b9efeae3e0917a52737bbd5127305b851b2a5b0b68c3bb"
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
