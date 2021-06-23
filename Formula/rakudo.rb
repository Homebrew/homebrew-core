class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  # NOTE: Please keep these values in sync with moarvm & nqp when updating.
  url "https://github.com/rakudo/rakudo/releases/download/2021.06/rakudo-2021.06.tar.gz"
  sha256 "eec13a7c8c44313ea8d6804d6a10c99faf49492e4ffba6e75267acb52ba63d86"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_big_sur: "d0a8addc79c688704afeb06c5452457d1f0dc898d50920d4e4a0b8bd1efd9e0b"
    sha256 big_sur:       "c1648e9fea3bb544db8e3b11a74b21565c9384e4bcaabb09669e95b84791abd1"
    sha256 catalina:      "5b467dd6574efa7cedbdfc5932495e6d9ed71274c9b867c384b826b953949808"
    sha256 mojave:        "e081300247c47462beaa31438cb07128731713cc4d41428a2ba3274ddef29377"
  end

  depends_on "nqp"

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-nqp=#{Formula["nqp"].bin}/nqp"
    system "make"
    system "make", "install"
    bin.install "tools/install-dist.p6" => "perl6-install-dist"
  end

  test do
    out = shell_output("#{bin}/perl6 -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end
