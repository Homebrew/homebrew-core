class Screenfetch < Formula
  desc "Generate ASCII art with terminal, shell, and OS info"
  homepage "https://github.com/KittyKatt/screenFetch"
  url "https://github.com/KittyKatt/screenFetch/archive/v3.9.1.tar.gz"
  sha256 "aa97dcd2a8576ae18de6c16c19744aae1573a3da7541af4b98a91930a30a3178"
  license "GPL-3.0"
  head "https://github.com/KittyKatt/screenFetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6f7e61ea4717eef72e68b006bcef5d6ff1aab08f7ba25f0a5c6b8e014ffb530b"
    sha256 cellar: :any_skip_relocation, big_sur:       "ab904d997e7f65041ea053d21da1b9acc385913f7d4051c7338bea85353a390b"
    sha256 cellar: :any_skip_relocation, catalina:      "ab904d997e7f65041ea053d21da1b9acc385913f7d4051c7338bea85353a390b"
    sha256 cellar: :any_skip_relocation, mojave:        "ab904d997e7f65041ea053d21da1b9acc385913f7d4051c7338bea85353a390b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f7e61ea4717eef72e68b006bcef5d6ff1aab08f7ba25f0a5c6b8e014ffb530b"
  end

  def install
    bin.install "screenfetch-dev" => "screenfetch"
    man1.install "screenfetch.1"
  end

  test do
    system "#{bin}/screenfetch"
  end
end
