class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2020.09/rakudo-2020.09.tar.gz"
  sha256 "a79e023e32f17415516369e2ee2f3e49e1c2931ca1430b53079ec77db4e5eec7"
  license "Artistic-2.0"

  bottle do
    sha256 "d7e3ace67da7a3edc74defd93ee00e4c119d92fffaab8adeacf173299f755b81" => :catalina
    sha256 "9d738e1b230eb11240aa8e1a06762170602a17fa115b034b9c6156ad325b6053" => :mojave
    sha256 "75e64cded6fbb8a17aa748a8b4df86d4aa31c9793fa41cab020514273c0190b3" => :high_sierra
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
