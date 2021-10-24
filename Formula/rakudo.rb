class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2021.10/rakudo-2021.10.tar.gz"
  sha256 "b174c7537328efb5e3f74245e79fa7159b70131b84c597916cf5a65c2aca24a1"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_big_sur: "5a05a505f206fb3e32f2c9f88cef7e882cef88eda6f0b65b1995987f440fc9a2"
    sha256 big_sur:       "d0a9572620e7bd9350ddb2d89dcd47f5e03e286e38c78e5c50fdd1f58916cffd"
    sha256 catalina:      "c588cbcbd102bd1df62b32db92586f07c6eaaa1e34d08cd69a7d6f35b47e8625"
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
