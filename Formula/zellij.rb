class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.34.4.tar.gz"
  sha256 "687e30a3e6916cdd7189ab04ff4b170bc5e09edd937637f0388b3f8432d0fc49"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2693ca536e7deb42ae5dab432000b8172b5455266ce2ec35955685ff1d783757"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c1144f66f1bd110bffaa1344208e402a6dc9037c1cef7e335fa2df0a7b92bfa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efd044e9c2e2935d19da8c006987b7ac5c54787d485f3326887d3d8f3bff04a2"
    sha256 cellar: :any_skip_relocation, ventura:        "6c46488e3a903fb16712ce7c3f6b884633b1587cb68e7209b2cddcacb268a78b"
    sha256 cellar: :any_skip_relocation, monterey:       "86ca5cc23ac07ad18b8df584dc424b493d1b21498a6a36a974941149ec21bf0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a4e92aad60e91ff30d92b781a3c52d603de784eb809e6d083e08651029ad85e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4f3ecf0a028d0eb6e296978b78a18c7179a7ea58cd1b9b3880452d32e64ec78"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
