class TinyFugue < Formula
  desc "Programmable MUD client"
  homepage "https://tinyfugue.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tinyfugue/tinyfugue/5.0%20beta%208/tf-50b8.tar.gz"
  version "5.0b8"
  sha256 "3750a114cf947b1e3d71cecbe258cb830c39f3186c369e368d4662de9c50d989"
  revision 1

  bottle do
    sha256 "24ef105267f27da0182f9f179ab73c2388230f3886b20697ff98495a235feeb4" => :catalina
    sha256 "2196e7b32acfb7604f19b8734d5425b32650ff1154f6c327313b8d18c52ffda1" => :mojave
    sha256 "32fcc0d6629da120ee1698b6185aaea0387519861182a4d6f10e6c67e9455405" => :high_sierra
    sha256 "cbdc761189ce2c20a0a00b2ba2bfe930d0b149ea932dda7c562fa36d6b199e7e" => :sierra
  end

  depends_on "libnet"
  depends_on "openssl@1.1"
  depends_on "pcre"

  conflicts_with "tee-clc", :because => "both install a `tf` binary"

  # pcre deprecated pcre_info. Switch to HB pcre-8.31 and pcre_fullinfo.
  # Not reported upstream; project is in stasis since 2007.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/tiny-fugue/5.0b8.patch"
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
