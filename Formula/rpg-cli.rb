class RpgCli < Formula
  desc "Your filesystem as a dungeon!"
  homepage "https://github.com/facundoolano/rpg-cli"
  url "https://github.com/facundoolano/rpg-cli/archive/refs/tags/0.4.1.tar.gz"
  sha256 "2b68e9c53ff7fcebb319aa741e008b1f8c2ed714558302c1707a1fc87fa09164"
  license "MIT"

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
