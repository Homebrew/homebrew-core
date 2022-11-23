class Webalizer < Formula
  desc "Web server log file analysis"
  homepage "https://web.archive.org/web/20200622121953/www.webalizer.org/"
  url "https://web.archive.org/web/20200205152356/ftp.mrunix.net/pub/webalizer/webalizer-2.23-08-src.tgz"
  mirror "https://deb.debian.org/debian/pool/main/w/webalizer/webalizer_2.23.08.orig.tar.gz"
  sha256 "edaddb5aa41cc4a081a1500e3fa96615d4b41bc12086bcedf9938018ce79ed8d"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    sha256 arm64_ventura:  "f26eca3adbd5012374dcf7fba0940ba0fad5522292a5add43ce5e8ae9cfd1bb1"
    sha256 arm64_monterey: "0eec79580ef41a980a2c3fd9161bee665d87eee2d0bed14a89eee1e285b91313"
    sha256 arm64_big_sur:  "e6cc3224691d03aa7a7c2c90b53372ba3bcd4a50d15ce849a4403457690bdbc7"
    sha256 ventura:        "91e8871f5afbd71654822b90b3202062a74604c89653a00b76e769ce3e9b20c8"
    sha256 monterey:       "d74f9239455491a88840a46ca4a58395186467530de79e41bfde176d8e9171ec"
    sha256 big_sur:        "e58bbbdad2e72611dd20dd334178066182298531041f0d48c5d31f9ff8583812"
    sha256 catalina:       "19cff82d601ab1b2ae54f16706dd0e81f1c85c4facc752afe8afa9a9a20b86ae"
    sha256 x86_64_linux:   "575d679a701bc2255e511318c0bec1c7099ca836d9b89b31f49a2c90e886b2d9"
  end

  deprecate! date: "2022-05-29", because: :unmaintained

  depends_on "berkeley-db@5"
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
