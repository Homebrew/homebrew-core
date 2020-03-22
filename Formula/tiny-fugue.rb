class TinyFugue < Formula
  desc "Programmable MUD client"
  homepage "https://tinyfugue.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tinyfugue/tinyfugue/5.0%20beta%208/tf-50b8.tar.gz"
  version "5.0b8"
  sha256 "3750a114cf947b1e3d71cecbe258cb830c39f3186c369e368d4662de9c50d989"
  revision 2

  bottle do
    sha256 "d10777dd98ae76a048caed1179f7a65f8ee59256dcb94cfcd89ac1da0e135209" => :catalina
    sha256 "ea162f2b1644a44d95a2847ec34133661008fff66306e3eda790a25f253f2165" => :mojave
    sha256 "b1ddefa5c2a52f3399f5a90c0586d65e5e7ccc9940715cbe682a1a30e8dc6e76" => :high_sierra
  end

  depends_on "libnet"
  depends_on "openssl@1.1"
  depends_on "pcre"

  conflicts_with "tee-clc", :because => "both install a `tf` binary"

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
