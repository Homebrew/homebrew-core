class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.31.1.tar.gz"
  sha256 "8fbe83ec4f4dcb5c157c5755978d00de6dfa2c9790c3788262f23c8d1b75350b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3b2e1a5adfacb5778f6e218217368e6626e7dfb95ea271abc3489fc6c7dbc3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71391577095276a879525a741c783ac77749facb9c3872c91ba06abbfe5ecabb"
    sha256 cellar: :any_skip_relocation, monterey:       "f041f7fa953cb673a76d47e09f4141798c3f023f827353cd4935f66b2ca04729"
    sha256 cellar: :any_skip_relocation, big_sur:        "8497a88ce94b1c01aa5e32e1b6de8d4b2496ad1cef3d275d69719f0e42bd13ca"
    sha256 cellar: :any_skip_relocation, catalina:       "747d1c1f8cad28f635bc02a0bc7aa6af811cccc0c3c077c96596afcf055a4415"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdda11419462c87bd51ca5f7e858e0d64bfebcb95fa158a2db5d53840e67f611"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match(/keybinds:.*/, shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
