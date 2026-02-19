class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2026.01/rakudo-2026.01.tar.gz"
  sha256 "40c5b9120c3ef9d737c0f122f9138c57245c442732582fc5a4072732e5188c91"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3906c548e8e13e5f487799d23670a270e53c98a8032209701636bcd6f7f8675b"
    sha256 arm64_sequoia: "8d95667f3d35a6df882f4d19635403f6373c2cfb211ec364d529154b5aa422ea"
    sha256 arm64_sonoma:  "eb56eb63a6b00f8b15c3280d06f85b4da228bb498a1bf5eda1f09b72d37f70c4"
    sha256 sonoma:        "d2aa48964410898c48ea10f7a8aef8141984e638043e19873fdcf25aa3ba220b"
    sha256 arm64_linux:   "5223e80f8f453547dac07771b8e0bd265fdee967811c864f5fb40addf554117e"
    sha256 x86_64_linux:  "23def1011ddcccf36d51508bb45b893899b60ad74c4b4c6d7d8d5db665533a36"
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
