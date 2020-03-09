class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2020.02.1/rakudo-2020.02.1.tar.gz"
  sha256 "7bb27366c0fe7dfd4c5bd616903208a6d63d71f420d14ec0ffa661ca1c8ecae1"
  revision 1

  bottle do
    sha256 "b9b0c8759f308500fad6d15e7625dfba6735d66e5773b11f00304bac9924f2d3" => :catalina
    sha256 "2e81f3feff930473ee6b0e36fb33092e72ab7a8e84c250074fbefafdb4db88aa" => :mojave
    sha256 "89114bb50c2a4699d684fd2671ffd57fe208c8e375eac42e2b3ae055067c3c6f" => :high_sierra
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
