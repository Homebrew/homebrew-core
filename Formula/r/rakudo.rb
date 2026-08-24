class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2026.08/rakudo-2026.08.tar.gz"
  sha256 "29ea82b26698889ebf6786a9dae1732309d7187a00bf3609cb17df69a62634cd"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "58eafe270ce9c931fbf264902f7332a833e606c38c89c69afa20a59159ebda3e"
    sha256 arm64_sequoia: "483ef2a7a42684fcd7849a87d53001cf072e29f4890934858dc1590b46670fbb"
    sha256 arm64_sonoma:  "a167b5aa12dd88fb10c56f07c0e7af72c801f44fcfb653697e8ade6bec09266a"
    sha256 sonoma:        "8dca713d9f1c5fe2bb377f2d9b73c045864319e086c97e2c903c8ab1cbc5f06d"
    sha256 arm64_linux:   "01f107e6e9f86b5eb6e4621c032738d6206c4ca8ac56fcaa9744682368095a22"
    sha256 x86_64_linux:  "7d300ab0be84f0e533f2bf38ff0f3afdf8e7a31e85b08225513683757161ddea"
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
