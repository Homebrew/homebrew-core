class Screenfetch < Formula
  desc "Generate ASCII art with terminal, shell, and OS info"
  homepage "https://github.com/KittyKatt/screenFetch"
  url "https://github.com/KittyKatt/screenFetch/archive/v3.9.1.tar.gz"
  sha256 "aa97dcd2a8576ae18de6c16c19744aae1573a3da7541af4b98a91930a30a3178"
  license "GPL-3.0"
  head "https://github.com/KittyKatt/screenFetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d88f370f36c942227b1beb20c7fd27934beb6f8edcc3b8c1e713c1bf0910672"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a8a196b1d61f4515270b2009a878dd0ca86052333ef1fea478f085c53b9b042"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f7e61ea4717eef72e68b006bcef5d6ff1aab08f7ba25f0a5c6b8e014ffb530b"
    sha256 cellar: :any_skip_relocation, ventura:        "3c4aece890a6db78cd9ad157a977f6c8fcafa750c9a1d10dfd6b468a9fcb29a7"
    sha256 cellar: :any_skip_relocation, monterey:       "64f48b67bd19de55e86169870401c92fc53229b0dfb72d7fb82a266569cf6b1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab904d997e7f65041ea053d21da1b9acc385913f7d4051c7338bea85353a390b"
    sha256 cellar: :any_skip_relocation, catalina:       "ab904d997e7f65041ea053d21da1b9acc385913f7d4051c7338bea85353a390b"
    sha256 cellar: :any_skip_relocation, mojave:         "ab904d997e7f65041ea053d21da1b9acc385913f7d4051c7338bea85353a390b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f7e61ea4717eef72e68b006bcef5d6ff1aab08f7ba25f0a5c6b8e014ffb530b"
  end

  # `screenfetch` contains references to `/usr/local` that
  # are erronously relocated in non-default prefixes.
  pour_bottle? only_if: :default_prefix

  def install
    bin.install "screenfetch-dev" => "screenfetch"
    man1.install "screenfetch.1"
  end

  test do
    system "#{bin}/screenfetch"
  end
end
