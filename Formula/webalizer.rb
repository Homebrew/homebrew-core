class Webalizer < Formula
  desc "Web server log file analysis"
  homepage "http://www.webalizer.org"
  url "ftp://ftp.mrunix.net/pub/webalizer/webalizer-2.23-08-src.tgz"
  mirror "https://deb.debian.org/debian/pool/main/w/webalizer/webalizer_2.23.08.orig.tar.gz"
  sha256 "edaddb5aa41cc4a081a1500e3fa96615d4b41bc12086bcedf9938018ce79ed8d"
  revision 2

  bottle do
    sha256 "c7b023658cc745cb0e5d383953e23a2d5a07dcf08b8e4addee7b7a108ef3a725" => :catalina
    sha256 "525c739550139303d96d823e9f50aca6255bb77eac70d45f2c1259aa59755f6b" => :mojave
    sha256 "e27c0dd7038a5a82e6fa127428c0b98750801e343b1b973b05bb08f38b055cdd" => :high_sierra
    sha256 "cb42abb300bb5dc9639c811a13e24cca1be2cceee01d02eabb1ec149414569d4" => :sierra
    sha256 "2bae3de97730aa72807cadcfda25ac395f3e30608d865df998fb474e75d4c780" => :el_capitan
  end

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
    (testpath/"test.log").write "127.0.0.1 user-identifier homebrew [10/Oct/2000:13:55:36 -0700] \"GET /beer.gif HTTP/1.0\" 200 2326"
    system "#{bin}/webalizer", "-c", etc/"webalizer.conf.sample", testpath/"test.log"
    assert_predicate testpath/"usage.png", :exist?
    assert_predicate testpath/"index.html", :exist?
  end
end
