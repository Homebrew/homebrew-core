class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  # NOTE: Please keep these values in sync with moarvm & nqp when updating.
  url "https://github.com/rakudo/rakudo/releases/download/2021.09/rakudo-2021.09.tar.gz"
  sha256 "eec9a084e036b76fa4f9c68e9ccebf819fd13aafdc356892f0560eed1e8cf425"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_big_sur: "399858c59537edc692da506005d517cc05374a9efe05ba7e47cd947b5c80d829"
    sha256 big_sur:       "089cec956db676e699ab062d5eea7139916a045346a5475d1ac26c84259dcafe"
    sha256 catalina:      "28320900a5c12a34fdf4ce0c36b521f592446cc9171e203a10fc0dadd5197488"
    sha256 mojave:        "08c7f7bb0cc04019314232620ffef7920208e99340af5d2820322c5994f04f1d"
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
