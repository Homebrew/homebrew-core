class RpgCli < Formula
  desc "Your filesystem as a dungeon!"
  homepage "https://github.com/facundoolano/rpg-cli"
  url "https://github.com/facundoolano/rpg-cli/archive/refs/tags/1.0.1.tar.gz"
  sha256 "763d5a5c9219f2084d5ec6273911f84213e5424f127117ab0f1c611609663a8b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ccaa9f4311164d4bcf2c242786158f89e7df7c2dc82e01a4a44267e4a3add74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31e4b31edd2178a88a66ec372934ba55bd7ff46a45c708d61f416176b4319557"
    sha256 cellar: :any_skip_relocation, monterey:       "edac7b05be2a3677bf1ad4e82546711c8aaacd0c2a69f13071ef0e468615fe56"
    sha256 cellar: :any_skip_relocation, big_sur:        "55d33b765bb854c44512494989f559362c788926dc10349dd303dc49f8ad5bb1"
    sha256 cellar: :any_skip_relocation, catalina:       "dc5072e0f7d57238bd57ae57ac736724876476b1337f7b8f4f8ac27547c2db15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e207b3c28ec5bda9b8b0c7f7a499594656cef0b097b8ac86ff608c3ee9889f0c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rpg-cli").strip
    assert_match "hp", output
    assert_match "equip", output
    assert_match "item", output
  end
end
