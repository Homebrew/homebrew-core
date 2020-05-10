class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2020.05/rakudo-2020.05.tar.gz"
  sha256 "86d1986c9a5ad1c7fe0f8875f16830cd3c4e84a3a3e05ee7e01e5234432aa121"

  bottle do
    sha256 "b8d45b1380bb068e06fc69021d81b4ea496b25d0dc8423a8047b9ac031b83bd3" => :catalina
    sha256 "dcf334615beae3bd335bb73f9484f2f6982d00dd696cdaed9f5b7f92b8079de6" => :mojave
    sha256 "bd4089e60c741ea4e65c15bc5ef9c7072fc9b82854bf4bc58ef2b792685f47c8" => :high_sierra
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
