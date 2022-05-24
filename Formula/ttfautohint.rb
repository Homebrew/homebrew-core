class Ttfautohint < Formula
  desc "Auto-hinter for TrueType fonts"
  homepage "https://www.freetype.org/ttfautohint/"
  url "https://downloads.sourceforge.net/project/freetype/ttfautohint/1.8.4/ttfautohint-1.8.4.tar.gz"
  sha256 "8a876117fa6ebfd2ffe1b3682a9a98c802c0f47189f57d3db4b99774206832e1"
  license any_of: ["FTL", "GPL-2.0-or-later"]

  livecheck do
    url "https://sourceforge.net/projects/freetype/rss?path=/ttfautohint"
    regex(%r{url=.*?/ttfautohint[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6aa8eb3acf16503b4f18ff09c7a072449e1b1c519bb8b72a7827ec8242a9c9b1"
    sha256 cellar: :any,                 arm64_big_sur:  "1ff2650d6b448e25018921dd855a32d1414c7491fef92f44af042ca1025b1976"
    sha256 cellar: :any,                 monterey:       "8ab23158e7597f79406f2bffd1e5557eb146d8055d73cbcea589cf26b57a32fc"
    sha256 cellar: :any,                 big_sur:        "0fceaf938c626642f90f505ca041b14c82696a8b9897504a92415296d635a292"
    sha256 cellar: :any,                 catalina:       "e5ad45157f4260f5cdfc68595ca2af5bd8524a342b47e3e39c78afa88da3b0d9"
    sha256 cellar: :any,                 mojave:         "dc0fb9212fe1535397bb7c42468bd80902810895d05ebb70fb5da557a38b39f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68214f0cc124de6b895152c8b780ea5aae067ce0ac571074a472d1723260c94b"
  end

  head do
    url "https://repo.or.cz/ttfautohint.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "libpng"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-doc",
                          "--without-qt"
    system "make", "install"
  end

  test do
    if OS.mac?
      font_name = (MacOS.version >= :catalina) ? "Arial Unicode.ttf" : "Arial.ttf"
      font_dir = "/Library/Fonts"
    else
      font_name = "DejaVuSans.ttf"
      font_dir = "/usr/share/fonts/truetype/dejavu"
    end
    cp "#{font_dir}/#{font_name}", testpath
    system bin/"ttfautohint", font_name, "output.ttf"
    assert_predicate testpath/"output.ttf", :exist?
  end
end
