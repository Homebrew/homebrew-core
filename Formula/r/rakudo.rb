class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2025.02/rakudo-2025.02.tar.gz"
  sha256 "fb5b1bdebd5690fce37853c3f0a49dfc8c2a14830124365ace40c6b280b6f463"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "7586ee89d832e3e9abb7ecbfd314353b2269fc547bc7a0fa3768a9d5f7393a88"
    sha256 arm64_sonoma:  "660939aceccc433517d8e82e05d7a5a7e04154d64481b3ad6774666a35f012ca"
    sha256 arm64_ventura: "5282ec6a4749fd09e3374513d54a48652c7a3818e47c27c6788d99d45f51e162"
    sha256 sonoma:        "27ac0060aa2d08c4b07b3c3678cb6c0125037b35345b4c70b190202953770993"
    sha256 ventura:       "f7e6dfaddc26254dd5ac4de276cc5c69d3382c302b73c6f7734bf43ee2c78bcf"
    sha256 x86_64_linux:  "3170709d560e402423f32a728b28ac81bdc54d00ecbe0cdca13f069c7f77391a"
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
