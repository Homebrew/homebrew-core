class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2026.04/rakudo-2026.04.tar.gz"
  sha256 "4adf4639cb877acc82d8e55360cd4be041e011ed589126b285d7621c2759a63d"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e13fafc8182d2cd7f672f1e494a39bc48be7bd21c8145f019d8db298e141ac92"
    sha256 arm64_sequoia: "9394b0213a9debc2c2228fc3654a581286880a4a35eac756fc704d78373df447"
    sha256 arm64_sonoma:  "b8b904073108c5a30485db67f61f7eb6d384dc130400f078da55e163251f2c8d"
    sha256 sonoma:        "5792c1e4e2e743ae8c85a32b9f30f37166a96a5f741f6e5906989f56f32e0715"
    sha256 arm64_linux:   "4475ff3a7efb2b0b7027c15016f6b645f93fe8d3c2064894c019347dd11ad13f"
    sha256 x86_64_linux:  "33524254f8392fb6a946f80fea558ef2c4e899b042327960a901df10c653d280"
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
