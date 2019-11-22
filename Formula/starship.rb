class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.26.4.tar.gz"
  sha256 "80b44efd22a8a7305c8cb31acf9b703d589f97fce009cc6be20105ff3a3d3d0c"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "16254bddaf4ce0d09289cfbf9125afde700319e0ba8de11dc8e9c43bc184bb9a" => :catalina
    sha256 "53b227ee4a51ad07841f5dc5d61e19dc5dab06f211c49e1cdfa9a8633dac62ca" => :mojave
    sha256 "2c0273375dc0ca170ec4cb98474df3438b7a67e55f94d2bb78e3a56d424a91c4" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
