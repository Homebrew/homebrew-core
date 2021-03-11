class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  # NOTE: Please keep these values in sync with moarvm & nqp when updating.
  url "https://github.com/rakudo/rakudo/releases/download/2021.02.1/rakudo-2021.02.1.tar.gz"
  sha256 "c8ea8d8bff3c3c983d1f7967321bcb5b72043b2fb5f3da6e8187af5306e998f7"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_big_sur: "ed6db66da0fa94a210c9db1a8a4486b7813419b63a20e2c2e5eeceb013f1cbfc"
    sha256 big_sur:       "22d5bc5afa03f09243ac994161429056caf3b07309c215bbf397c4a4f0f85516"
    sha256 catalina:      "7c8cc982aad9bc797f20cbae03bff9ec742d4bf77d327e10718b4073a6508f42"
    sha256 mojave:        "0a466256adacb7707e5c687ed4ce9f840dfd18eda78bd93847a4cddb26b5c404"
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
