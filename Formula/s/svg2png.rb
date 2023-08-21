class Svg2png < Formula
  desc "SVG to PNG converter"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/svg2png-0.1.3.tar.gz"
  sha256 "e658fde141eb7ce981ad63d319339be5fa6d15e495d1315ee310079cbacae52b"
  license "LGPL-2.1"
  revision 2

  livecheck do
    url "https://cairographics.org/snapshots/"
    regex(/href=.*?svg2png[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6ea6d9de3e844679b033653d791e7b4e9d323e9851d5d69ae88e2aedcf9de01d"
    sha256 cellar: :any,                 arm64_monterey: "d27d975e6029a87783131f8c4dc4aa41da61901f01d13a44aebf1a69b27be9f3"
    sha256 cellar: :any,                 arm64_big_sur:  "4a1dd056166d51270fa14a9957dfabecea6c9ec391c0a476b8dbba95033aaa48"
    sha256 cellar: :any,                 ventura:        "c682123ac6c635638ab1021e224c55556f3f59dbdf01ca618d709d34e975f00c"
    sha256 cellar: :any,                 monterey:       "5d673b22dbf70d13fc5488e31daaaecdbe526035358b93f05c0d311270d0779c"
    sha256 cellar: :any,                 big_sur:        "2887e4be3e04f38930ca99045b751719f73632466d758370f8fb61caf41b9616"
    sha256 cellar: :any,                 catalina:       "2131b421e798b99ea017a9b1955ceb828596c54d559674af019924714de3c5ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26430f8c9086f1f7d1e460dc8588c57a2fb696527278006c68f41641ff88bd42"
  end

  depends_on "pkg-config" => :build
  depends_on "libsvg-cairo"

  def install
    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    unless OS.mac?
      inreplace "src/Makefile.in", "$(LINK) $(svg2png_LDFLAGS) $(svg2png_OBJECTS)",
                                   "$(LINK) $(svg2png_OBJECTS) $(svg2png_LDFLAGS)"
    end

    system "./configure", *std_configure_args, "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/svg2png", test_fixtures("test.svg"), "test.png"
    assert_predicate testpath/"test.png", :exist?
  end
end
