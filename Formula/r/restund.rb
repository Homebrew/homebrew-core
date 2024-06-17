class Restund < Formula
  desc "Modular STUN/TURN server"
  homepage "https://web.archive.org/web/20200427184619/www.creytiv.com/restund.html"
  url "https://sources.openwrt.org/restund-0.4.12.tar.gz"
  sha256 "3170441dc882352ab0275556b6fc889b38b14203d936071b5fa12f39a5c86d47"
  license "BSD-3-Clause"
  revision 9

  bottle do
    sha256 arm64_ventura:  "b9ba059a6225c2f65e8a9c5e6f6f1e0e697026a5adbd11feebe829bcda207e09"
    sha256 arm64_monterey: "0d6aba84bcbe504021c1fd5add9804830061fcab75ec2fb596645bc50c3f9eae"
    sha256 arm64_big_sur:  "ad737b821dd36a44e0c9f396c4b3e4e647fc3cc090ecf9b7c4a1b333264c69f6"
    sha256 ventura:        "0748883809bea3879eb9d559b4989c4cd3b510816e49a85c25eb476bcf3f8280"
    sha256 monterey:       "b01e965a4ef6ce7c29e03c14ac544a3f2e74014ed8eb4214c926f5ea54cff5b0"
    sha256 big_sur:        "73ad50480e142d78199a62c58557e5235b7ab987447688620314af3a9e692b37"
    sha256 x86_64_linux:   "edc5342cec41fc3fe065907f880cfaafd50dd83258a296c43b1144ed63a7b8d0"
  end

  disable! date: "2024-01-12", because: :unmaintained

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
