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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "9efb3056dde7f1557a920fe397c958c996c0f34d2a03d8913255845f9661f2e2"
    sha256 cellar: :any,                 arm64_sequoia:  "707de245f1d8feaa830ef678f1d658c59a8a2ed6a8b1aba8aa65b9981e2d0758"
    sha256 cellar: :any,                 arm64_sonoma:   "9342d7fcb9ceff49803164315b7e08d844f4d7792589ec1b4a737265a39acb7c"
    sha256 cellar: :any,                 arm64_ventura:  "e783c67f64f6aeeaf22b635133eacac161f936bb5c71479109d5bc86ee188c98"
    sha256 cellar: :any,                 arm64_monterey: "6aa8eb3acf16503b4f18ff09c7a072449e1b1c519bb8b72a7827ec8242a9c9b1"
    sha256 cellar: :any,                 arm64_big_sur:  "1ff2650d6b448e25018921dd855a32d1414c7491fef92f44af042ca1025b1976"
    sha256 cellar: :any,                 sonoma:         "84a63397be31f725cffd64eed4b7e40e776e94f6ef1fe8dea84a4adc172592f7"
    sha256 cellar: :any,                 ventura:        "288ff076d988ce45c5a253188f1da0a7a7fbded29b52499678e3c649c61ec226"
    sha256 cellar: :any,                 monterey:       "8ab23158e7597f79406f2bffd1e5557eb146d8055d73cbcea589cf26b57a32fc"
    sha256 cellar: :any,                 big_sur:        "0fceaf938c626642f90f505ca041b14c82696a8b9897504a92415296d635a292"
    sha256 cellar: :any,                 catalina:       "e5ad45157f4260f5cdfc68595ca2af5bd8524a342b47e3e39c78afa88da3b0d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6e396a76f14968d0778b51a5093552d6e63e643ebc0b5d7f5b06719d8c8932f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68214f0cc124de6b895152c8b780ea5aae067ce0ac571074a472d1723260c94b"
  end

  head do
    url "https://repo.or.cz/ttfautohint.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "libpng"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--without-doc",
                          "--without-qt",
                          *std_configure_args
    system "make", "install"
  end

  test do
    if OS.mac?
      font_name = "Arial Unicode.ttf"
      font_dir = "/Library/Fonts"
    else
      font_name = "DejaVuSans.ttf"
      font_dir = "/usr/share/fonts/truetype/dejavu"
    end
    cp "#{font_dir}/#{font_name}", testpath
    system bin/"ttfautohint", font_name, "output.ttf"
    assert_path_exists testpath/"output.ttf"
  end
end
