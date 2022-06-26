class Webalizer < Formula
  desc "Web server log file analysis"
  homepage "https://web.archive.org/web/20200622121953/www.webalizer.org/"
  url "https://web.archive.org/web/20200205152356/ftp.mrunix.net/pub/webalizer/webalizer-2.23-08-src.tgz"
  mirror "https://deb.debian.org/debian/pool/main/w/webalizer/webalizer_2.23.08.orig.tar.gz"
  sha256 "edaddb5aa41cc4a081a1500e3fa96615d4b41bc12086bcedf9938018ce79ed8d"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 arm64_monterey: "83f6bd5042bab75a5ffbfc154d31217c4a7ca770d105ae8fa19163d398f196d9"
    sha256 arm64_big_sur:  "e5dd2dbc62dc88bcae72d46858d1ffc12bd32504e791419487e543bb0cc016c9"
    sha256 monterey:       "5dc996c4c3ba12ebe94f4e11efe803128014d66a2b366baa4ef9bdaaad36da16"
    sha256 big_sur:        "c2b261ea2ecd03ee71f43ecc38ca50ad2de689199fafe0711bc639da2a0af94c"
    sha256 catalina:       "c7b023658cc745cb0e5d383953e23a2d5a07dcf08b8e4addee7b7a108ef3a725"
    sha256 mojave:         "525c739550139303d96d823e9f50aca6255bb77eac70d45f2c1259aa59755f6b"
    sha256 high_sierra:    "e27c0dd7038a5a82e6fa127428c0b98750801e343b1b973b05bb08f38b055cdd"
    sha256 sierra:         "cb42abb300bb5dc9639c811a13e24cca1be2cceee01d02eabb1ec149414569d4"
    sha256 el_capitan:     "2bae3de97730aa72807cadcfda25ac395f3e30608d865df998fb474e75d4c780"
    sha256 x86_64_linux:   "162c45cacfbf8619b563fd65ca79010add2bc05609886c27d3c15ed25c7fb22f"
  end

  deprecate! date: "2022-05-29", because: :unmaintained

  depends_on "berkeley-db"
  depends_on "gd"
  depends_on "libpng"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.log").write \
      "127.0.0.1 user-identifier homebrew [10/Oct/2000:13:55:36 -0700] \"GET /beer.gif HTTP/1.0\" 200 2326"
    system "#{bin}/webalizer", "-c", etc/"webalizer.conf.sample", testpath/"test.log"
    assert_predicate testpath/"usage.png", :exist?
    assert_predicate testpath/"index.html", :exist?
  end
end
