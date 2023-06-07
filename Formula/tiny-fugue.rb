class TinyFugue < Formula
  desc "Programmable MUD client"
  homepage "https://tinyfugue.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tinyfugue/tinyfugue/5.0%20beta%208/tf-50b8.tar.gz"
  version "5.0b8"
  sha256 "3750a114cf947b1e3d71cecbe258cb830c39f3186c369e368d4662de9c50d989"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 arm64_ventura:  "f1018454baaa50f76a0fcf885e400d42ab6eb5352f1436a34676b2090bc6c65b"
    sha256 arm64_monterey: "efbd40e8291c53ca89d75dc25c15b18e3cbbba58e1da3b99b200a8458128609e"
    sha256 arm64_big_sur:  "de2a1d16b807c1cede3b8f574a1dbaa5a8bda47b4c65307b33b975b9eec665f7"
    sha256 ventura:        "819d0189551a3ae5bd9d75e483308de4f058c1561529a09f1c5c3c6a556619f1"
    sha256 monterey:       "00c01c6ebfccc7d525bd0d901771f3b459fc62e28537be27c275976bed22fb4c"
    sha256 big_sur:        "c7e39f8d3cf009ff749208b5b2efa718a802a2ca82368273b1076a0607a10e76"
    sha256 catalina:       "d10777dd98ae76a048caed1179f7a65f8ee59256dcb94cfcd89ac1da0e135209"
    sha256 mojave:         "ea162f2b1644a44d95a2847ec34133661008fff66306e3eda790a25f253f2165"
    sha256 high_sierra:    "b1ddefa5c2a52f3399f5a90c0586d65e5e7ccc9940715cbe682a1a30e8dc6e76"
    sha256 x86_64_linux:   "c92a44ad82e402fb01b555a22f7e276a344d799b1b666ef76286a3397617770c"
  end

  deprecate! date: "2022-10-25", because: :unmaintained

  depends_on "libnet"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "ncurses"

  conflicts_with "tee-clc", because: "both install a `tf` binary"

  # pcre deprecated pcre_info. Switch to HB pcre-8.31 and pcre_fullinfo.
  # Not reported upstream; project is in stasis since 2007.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9dc80757ba32bf5d818d70fc26bb24b6f/tiny-fugue/5.0b8.patch"
    sha256 "22f660dc0c0d0691ccaaacadf2f3c47afefbdc95639e46c6b4b77a0545b6a17c"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-getaddrinfo",
                          "--enable-termcap=ncurses"
    system "make", "install"
  end
end
