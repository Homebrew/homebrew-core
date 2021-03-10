class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  # NOTE: Please keep these values in sync with moarvm & nqp when updating.
  url "https://github.com/rakudo/rakudo/releases/download/2021.02.1/rakudo-2021.02.1.tar.gz"
  sha256 "c8ea8d8bff3c3c983d1f7967321bcb5b72043b2fb5f3da6e8187af5306e998f7"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_big_sur: "9131816ea24c4914fe6c364bf65136e0ac76d49f6ce6cd20f65a083dba7f1b23"
    sha256 big_sur:       "cbbfb96a21aff57d11ff5906fa8026149173201aef3020f339a6c1c3e9b06a83"
    sha256 catalina:      "504b6bd87d94c0dc9ead713f4a35d0acfc50193ba8e4b62273305badae256607"
    sha256 mojave:        "94189e895d256ed04611c1b79c17bef9fa992a93b9332f82b0f79a8390d882c4"
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
