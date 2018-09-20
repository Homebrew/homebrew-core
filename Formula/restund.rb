class Restund < Formula
  desc "Modular STUN/TURN server"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/restund-0.4.12.tar.gz"
  sha256 "3170441dc882352ab0275556b6fc889b38b14203d936071b5fa12f39a5c86d47"

  bottle do
    cellar :any
    sha256 "489f651680461d466ab162ecbbc9f4e7acc554e3701b13828a5998de3e8accc4" => :mojave
    sha256 "05a527dfb0207ebd9b8a94ce4307ec0f106fa3c085851476eb36c27515d9b9fb" => :high_sierra
    sha256 "b54c91bb6457a8af37e55064d9f5093212ae7dc7c53863f4344f0862a0e6706e" => :sierra
    sha256 "520b20cfdfb1cb5da1ee3a147a707802f6cc77a289c80e2b04a4299446e67408" => :el_capitan
  end

  depends_on "libre"

  def install
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
