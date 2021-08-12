class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  # NOTE: Please keep these values in sync with moarvm & nqp when updating.
  url "https://github.com/rakudo/rakudo/releases/download/2021.07/rakudo-2021.07.tar.gz"
  sha256 "178afe4dc8b2f32e155eb2f8482e1125409edfd8451c39d33a472047047fab52"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_big_sur: "4d90cfe7ed383cf08371969e328b1413fc9e43ed3b5b19f797e1200c28922b73"
    sha256 big_sur:       "784e623782386b65f48e2e81ece1ed51d02baa3b484ca0305ed8ce36545597bf"
    sha256 catalina:      "92483aa7fcd0a102f3237de2555666af14cef671ed4af16f379dff967fb3879c"
    sha256 mojave:        "17a19f6424ada2286597a5d6991a309537d5e01996f37f0e934ecf56d9d65688"
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
