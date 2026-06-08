class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2026.05/rakudo-2026.05.tar.gz"
  sha256 "4bfae3eb970cf061f02d56f611425c8c425aab9b691cd3bffe1495ce56ab2067"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e7c044bed7c07526837efb2d52c20804beaf4e93c7081989bbede4046ef8d270"
    sha256 arm64_sequoia: "91378cd35d2cc1a042549263ef1a6386b406363c611ecfec358e2a44d2a7cb06"
    sha256 arm64_sonoma:  "d7bfdd4361f1f8daf0aa3876e50dc48684689bbbc84a2756af4a5a31c9cd92ae"
    sha256 sonoma:        "32a376fa67df890b4e9911e831e10ff73c8a2603cdff6638b572938d7c618bfa"
    sha256 arm64_linux:   "44b8cef39404b2185bbe977fb0f6c1e32d5980a5d121b96365975e50b24b4a00"
    sha256 x86_64_linux:  "031376b4eee20a887c97d6c618c899c451755343eb0000de6f724175ebaa085e"
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
