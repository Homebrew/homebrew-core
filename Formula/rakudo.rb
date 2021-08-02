class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  # NOTE: Please keep these values in sync with moarvm & nqp when updating.
  url "https://github.com/rakudo/rakudo/releases/download/2021.07/rakudo-2021.07.tar.gz"
  sha256 "178afe4dc8b2f32e155eb2f8482e1125409edfd8451c39d33a472047047fab52"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_big_sur: "41fb5d2795554412b5069df04db3522280cb1b90b13a4f1c0261087cc079dc8e"
    sha256 big_sur:       "f43ac99da246831d1bd15f2b22464f9a7891fd25b702948348d9864de6b6d221"
    sha256 catalina:      "cd63549b97b3f7c18e6504ffcc4989f6fb015c1d0fc1681d4a10409b1322ca8a"
    sha256 mojave:        "9d1ac5f1d88be3f8d17b1fd7e6bec52e93b453819f14fd9e034e7ee2596864bb"
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
