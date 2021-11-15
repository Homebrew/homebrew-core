class Svg2png < Formula
  desc "SVG to PNG converter"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/svg2png-0.1.3.tar.gz"
  sha256 "e658fde141eb7ce981ad63d319339be5fa6d15e495d1315ee310079cbacae52b"
  license "LGPL-2.1"
  revision 1

  livecheck do
    url "https://cairographics.org/snapshots/"
    regex(/href=.*?svg2png[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "90ca143e180739cc2ea63efb858b6da3696a03206a78a80310a537b3ce26be8e"
    sha256 cellar: :any, arm64_big_sur:  "7730ea28df0044d098709fc845e6d88d2d9d1297addcc4feb73a72334e168252"
    sha256 cellar: :any, monterey:       "d123e7b71b3cfe5a8a72751289c6e49a6c3abbfe7046a220a0ad48cd53f1315d"
    sha256 cellar: :any, big_sur:        "91ea80e51edffa9ff0f1b75637eb2eb89ebda2ab9b8fcfd94242d113dd6fff99"
    sha256 cellar: :any, catalina:       "9669d135c08480905ca33b97507af5cbca2315243358f022ffa3bbe5731bfca8"
    sha256 cellar: :any, mojave:         "fd2d0727b1ae83f458c17625894d0bf824dd9c58605a81528efb4332c17051c0"
    sha256 cellar: :any, high_sierra:    "c0495d355b1ca05b777814eb2bed14fbae20075a9aa1dd72bfdcdd2efd117587"
    sha256 cellar: :any, sierra:         "d3d9556295a1bed19da91bbe741d3980638bade739e37bbb19d01f517a5e442c"
    sha256 cellar: :any, el_capitan:     "327bbf146aedf651d8af446ae94a736fb89652cd8a4a7d8d0b00b1f6ca3f7693"
    sha256 cellar: :any, yosemite:       "8d6abbad01e2b307369b7feadf2b79232b9b1f248bf5f789aa8a3231caffedff"
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
