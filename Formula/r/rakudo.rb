class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2024.01/rakudo-2024.01.tar.gz"
  sha256 "717fc1b5d15b92de64b3094192d333483423397d386d620f1c398685137568e8"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "d4e12e064243abd490ff141e484d1f0d2280425d0aad4135acfaf5cec9087843"
    sha256 arm64_ventura:  "c0148a5713e7e5b2f7f02138cec6176def646583214711c48ec84fe5817d5c82"
    sha256 arm64_monterey: "e6896c5298f98cbaaae7da383c0844c95591e85508ce88f461c29495fe367e98"
    sha256 sonoma:         "3bc3130b7cef5be389dc95a8c7325f7899ea2c4514f5c41cff8e8e120d94f51c"
    sha256 ventura:        "5b5e721e7a55d66a47b52e816024a3412a831f45c17e192bb8804bd106f08c30"
    sha256 monterey:       "116661f45241a41e5838bb7e34ec62b17c12c7dda913cc684b93718e3b98e8df"
    sha256 x86_64_linux:   "0c4c74be80b75063d1a09cf19b27483b60d74675012d1b600f054df354e295d1"
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
