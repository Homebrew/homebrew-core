class Restund < Formula
  desc "Modular STUN/TURN server"
  homepage "https://web.archive.org/web/20200427184619/www.creytiv.com/restund.html"
  url "https://sources.openwrt.org/restund-0.4.12.tar.gz"
  sha256 "3170441dc882352ab0275556b6fc889b38b14203d936071b5fa12f39a5c86d47"

  livecheck do
    url "https://sources.openwrt.org/"
    regex(/href=.*?restund[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 "389b79ebc0bd2352f739496d27e8d684db16a4a371ff24c511dc0b2a6059e5ec" => :big_sur
    sha256 "904de3a9379dac2c1215b992e1aff7cfd42e09f288e5b88df1969c9ba1675050" => :catalina
    sha256 "7ec584f71cc4b6f54f30c1dfcae29e11f110b8f26506e1154e5646ce326923b1" => :mojave
    sha256 "2d5b243b9971a38fdc00c1d2d332e7875aa17f74ea4d1f083eeacbfaa38d004f" => :high_sierra
    sha256 "ea2c7e202307b9a48ed65020570d5ce3236b556757263cb16c35143baa92ca79" => :sierra
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
