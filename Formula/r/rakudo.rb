class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2024.05/rakudo-2024.05.tar.gz"
  sha256 "26be283bee73c696bd5089e07cad5ec6d79c7f65f9b422fbc7aca75321ee1f16"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "9c027c299fd7d5766a64f5639a285b0751877f313f1dce58239dc292a332b50f"
    sha256 arm64_ventura:  "2d0c327c0b1edb454ad5d01f0e1dd6cbe58fb1aa89481712ad5c38537f800bef"
    sha256 arm64_monterey: "f9d83bb552056fc29ece207baefba7a192ac0635d05ae26e5e5a9dec4e81b7cb"
    sha256 sonoma:         "c00bc9f5a2be008767edd7d45fe3c3d3a3eefaa9bf3272108563dd539ba4fdd8"
    sha256 ventura:        "eb2e26cb0c2196b0305991eec1ba36ea1b47e60c756ac23a30294968c562f8e8"
    sha256 monterey:       "9e87ed508b05a59cf7f155cb4a3104b4e9120d31810732ead65c82c46fa1d1f0"
    sha256 x86_64_linux:   "e4e464a4782a8330ae0b7c33d618eeedd039ab1a1e524ebc66fea33604ce7e93"
  end

  depends_on "libtommath"
  depends_on "libuv"
  depends_on "moarvm"
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
