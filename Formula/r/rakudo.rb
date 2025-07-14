class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2025.06/rakudo-2025.06.tar.gz"
  sha256 "202164a266f43091fde1f8cb22fdc45d9cfa03e9961aee708ba92b6d29087a72"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "11b954ac8cc6b3c11734e3bf05aa57547b134013b6d22acbd807aa141bed1e28"
    sha256 arm64_sonoma:  "39f621277db1abd264436867ae8cfd43b223f69b7de974425a55c6bffc23ed8f"
    sha256 arm64_ventura: "54666fb11f74d8c3dd62e0e88381eded9d22d3f665824b93786627c16dc0f206"
    sha256 sonoma:        "9601010bd1f43f9369b68bd11181eb0a955a406e6613233b22bfba99acc23b72"
    sha256 ventura:       "db6acbeb0d7c1a8a817c66e6aaa26c7797d9b627370994fe1824bb322094b2ad"
    sha256 arm64_linux:   "1eeea92f61218abd7567550513c5bcfebf1b76a8a2883057a6b256e68d0cb5d7"
    sha256 x86_64_linux:  "aaa1d2f0c67a4161940e67cc1008ed090f4c0fe493ec870e1c482c829c1349da"
  end

  depends_on "moarvm"
  depends_on "nqp"

  uses_from_macos "perl" => :build

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-nqp=#{Formula["nqp"].bin}/nqp"

    # Reduce overlinking on macOS
    if OS.mac?
      inreplace "Makefile" do |s|
        s.change_make_var! "M_LDFLAGS", "#{s.get_make_var("M_LDFLAGS")} -Wl,-dead_strip_dylibs"
      end
    end

    system "make"
    system "make", "install"
    bin.install "tools/install-dist.raku" => "raku-install-dist"
  end

  test do
    out = shell_output("#{bin}/raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end
