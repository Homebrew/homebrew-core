class Restund < Formula
  desc "Modular STUN/TURN server"
  homepage "https://web.archive.org/web/20200427184619/www.creytiv.com/restund.html"
  url "https://sources.openwrt.org/restund-0.4.12.tar.gz"
  sha256 "3170441dc882352ab0275556b6fc889b38b14203d936071b5fa12f39a5c86d47"
  license "BSD-3-Clause"
  revision 8

  # The sources.openwrt.org directory listing page is 2+ MB in size and
  # growing. This alternative check is less ideal but only a few KB. Versions
  # on the package page can use a format like 1.2.3-4, so we omit any trailing
  # suffix to match the tarball version.
  livecheck do
    url "https://openwrt.org/packages/pkgdata/restund"
    regex(/<dd [^>]*?class="version"[^>]*?>\s*?v?(\d+(?:\.\d+)+)/im)
  end

  bottle do
    sha256 arm64_ventura:  "8be5a6ff13e1c9810bf9bdccbaf64fe091ef9ca98164f615656536d1d83b2f5f"
    sha256 arm64_monterey: "8ba54062036994ee059c7c97f812d2b9e2c5dd371c55f4395e99d74871cae634"
    sha256 arm64_big_sur:  "59ab561a73c563a5c316779e7ba1caa849c2d7f65ac9c19af0ff6f38d299b5ff"
    sha256 ventura:        "1a27045ea0984a66dcb509c450d5515e9a42cf028f4425d9b75c2abec753d4e3"
    sha256 monterey:       "dc77aebcdfa08f395f6e359bbf8d06419172ae9aa60ae4946a5e11a63d2e407f"
    sha256 big_sur:        "27099608a5892cd0915dc19e2df7ebb663a9f16e4c84143f8b76fff9e463c2a4"
    sha256 catalina:       "1fcff615a8988cf26177e67f111d41b5b3a69e1814cfe5dd4bbfa06bb1de4977"
    sha256 x86_64_linux:   "13206619883a0eb7a213e79e60c98744bb27e18bf3974d90b896d2f0f933b778"
  end

  depends_on "libre"

  def install
    # Configuration file is hardcoded
    inreplace "src/main.c", "/etc/restund.conf", "#{etc}/restund.conf"

    libre = Formula["libre"]
    system "make", "install", "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}"
    system "make", "config", "DESTDIR=#{prefix}",
                              "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}"
  end

  test do
    system "#{sbin}/restund", "-h"
  end
end
