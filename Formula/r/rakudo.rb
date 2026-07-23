class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2026.06/rakudo-2026.06.tar.gz"
  sha256 "62da87c09e9757abd19bb34329b2398ba32c3015665dfa910cc86cde2a2ea6b8"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "93a46fe6fa349a0251c211975d5ae5af9e3dfe09283fa3e58312fa29a364e9c0"
    sha256 arm64_sequoia: "e7e5b0cc290c2a25fd12b140a562486a24cce39790590ea15412a0ff38688a30"
    sha256 arm64_sonoma:  "22eab527ad3b33c84ba3610f692db5d568e7d5f77842e9d1f6fbb819e89e61c8"
    sha256 sonoma:        "ee58ab072915f167951de0b6e4f5a2a9829db062e42911f5973fe6f806ba9e50"
    sha256 arm64_linux:   "b8fd773b81235b96fccb1b2fa22553344e16939426f99228ff854f1fccb7743e"
    sha256 x86_64_linux:  "d58a934dcbf2fdc80ac5cd164dbed6045fe8559f89dd043ef1f6ebd3bfc28838"
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
