class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2023.06/rakudo-2023.06.tar.gz"
  sha256 "da50fed9fa99cced37f8e450c6a023150804d627bf698a5c0d88cbe84f405e72"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "8ebed7b3a548af77e8579d7a0de0d8052349a76032fa5ff3198cccd1e9f33eb7"
    sha256 arm64_monterey: "d6a6e420169edd502ed8379d42d3ff922a408df73fd5aeb08f83ed50ab012906"
    sha256 arm64_big_sur:  "272b6fd0fc8fdfbb793458bbee9fb04f6f5671c439579bbe4d80b94a961592d8"
    sha256 ventura:        "e0530f839fbc9b25d9e7eef36d0542d1f08ee7626daa973d0ae925f21689e398"
    sha256 monterey:       "52b3d5eb22ddb2f1adbe6b4e974fc3e5fb931fd8877bea72627c0dc7495842e4"
    sha256 big_sur:        "9405bb16fa06a1fdf55b48fd09af907efccd8766d6052b498017e4c81dee3627"
    sha256 x86_64_linux:   "062155964aa252575b52176b7dcd3910b03fa0d7cc43d753fa7f956830876bdb"
  end

  depends_on "libtommath"
  depends_on "libuv"
  depends_on "nqp"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-nqp=#{Formula["nqp"].bin}/nqp"
    system "make"
    system "make", "install"
    bin.install "tools/install-dist.raku" => "raku-install-dist"
  end

  test do
    out = shell_output("#{bin}/raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end
