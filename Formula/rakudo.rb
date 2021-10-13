class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  # NOTE: Please keep these values in sync with moarvm & nqp when updating.
  url "https://github.com/rakudo/rakudo/releases/download/2021.09/rakudo-2021.09.tar.gz"
  sha256 "eec9a084e036b76fa4f9c68e9ccebf819fd13aafdc356892f0560eed1e8cf425"
  license "Artistic-2.0"
  revision 1

  bottle do
    sha256 arm64_big_sur: "eb53d38f6cfc2a609007bd499c180392b9088702ffc8c9015293118fd8109d9d"
    sha256 big_sur:       "5dcdeef93447e34ae5a7ec59e3e89a70d5fc6b429685c782916f6e7c55b8fd14"
    sha256 catalina:      "31e4c8c7544ae9c0262d05be12845bc29cb5e0b8f098a5ba7cf64465d2395d72"
    sha256 mojave:        "79e19227126f2f31aafa0da1b6097a27de274a2844969097fef7f7d07d149fb3"
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
