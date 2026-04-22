class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2026.03/rakudo-2026.03.tar.gz"
  sha256 "c2a015bbe3ad1405b47eb6308b070168613bbfdde596272a828382aa61c409ff"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1537034eb489ba8ebb74ba45c8890da0a0ff9450d149bc6abcf323cd93bbca11"
    sha256 arm64_sequoia: "5b57074ccf0be1cca9dba340cbe51cb0a321f63700e40d69df491859cf10ea2d"
    sha256 arm64_sonoma:  "597abf80c2823bb9fa6df7152842b49383a138ebc5bfeaca330b6c554cfab439"
    sha256 sonoma:        "59e8f047a57ff54b6c217c30f34737456d9b0ca72a0274b554ccdc42374818f6"
    sha256 arm64_linux:   "b155b472072ad7eeb2aef3ef728178d51b7581e7aae69d3f684e00ea336fc505"
    sha256 x86_64_linux:  "287e74e237cdfefc3eaca5ec5f45910fba3258e92a5e1372d1532c471bb2a779"
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
