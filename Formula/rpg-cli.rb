class RpgCli < Formula
  desc "Your filesystem as a dungeon!"
  homepage "https://github.com/facundoolano/rpg-cli"
  url "https://github.com/facundoolano/rpg-cli/archive/refs/tags/0.4.1.tar.gz"
  sha256 "2b68e9c53ff7fcebb319aa741e008b1f8c2ed714558302c1707a1fc87fa09164"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "254ec5c187fadfc48df5a7bfd329aab9357072b0f9896943d212a770f0f6a2b5"
    sha256 cellar: :any_skip_relocation, big_sur:       "1aa04ab7e110e6792cb420fbd54835ea39611380efe82693ab4f92666a6abfbe"
    sha256 cellar: :any_skip_relocation, catalina:      "fffa364cf607d471d91f73d0bbae3ca49b007e39aa6bc6e0d449977713046cf0"
    sha256 cellar: :any_skip_relocation, mojave:        "9b3d14e54c50e29169d6213a8272ddf05a874cfdd05b7e54acc50bd32e66ad8b"
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
