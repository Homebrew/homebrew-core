class Svg2png < Formula
  desc "SVG to PNG converter"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/svg2png-0.1.3.tar.gz"
  sha256 "e658fde141eb7ce981ad63d319339be5fa6d15e495d1315ee310079cbacae52b"
  revision 1

  bottle do
    cellar :any
    sha256 "fd2d0727b1ae83f458c17625894d0bf824dd9c58605a81528efb4332c17051c0" => :mojave
    sha256 "c0495d355b1ca05b777814eb2bed14fbae20075a9aa1dd72bfdcdd2efd117587" => :high_sierra
    sha256 "d3d9556295a1bed19da91bbe741d3980638bade739e37bbb19d01f517a5e442c" => :sierra
    sha256 "327bbf146aedf651d8af446ae94a736fb89652cd8a4a7d8d0b00b1f6ca3f7693" => :el_capitan
    sha256 "8d6abbad01e2b307369b7feadf2b79232b9b1f248bf5f789aa8a3231caffedff" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libsvg-cairo"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/svg2png", test_fixtures("test.svg"), "test.png"
    assert_predicate testpath/"test.png", :exist?
  end
end
