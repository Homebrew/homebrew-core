class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2025.11/rakudo-2025.11.tar.gz"
  sha256 "9f58f4ca075d740058a49a295e862a079dcdecb3b74c01f0717bb46135a7673c"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "15299f5b13d2fd111668edcdc74c9aa65334b7ef723380fd4145b597f2f50eef"
    sha256 arm64_sequoia: "f12387bd5163af49c5ec9b0b92f040577ee15b3892050868eabc0342c9605b5d"
    sha256 arm64_sonoma:  "0ee410dc70c3f08d00b9cb2e6d9c093e00815a16dcc1e51918374e3b4e864260"
    sha256 sonoma:        "b21db5d847f049abbbf34f3af9665def724e1bd81dcc41bfbff6cdcdf8f86e6f"
    sha256 arm64_linux:   "321bb2d7bad1c7981f8702314d8231d7f7e89c1327c31fdbeb3415f14695deff"
    sha256 x86_64_linux:  "d8220c88c6288e81e63e4bfb22dfcb0611eddc1d895364e4c952664c53d19ab2"
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
