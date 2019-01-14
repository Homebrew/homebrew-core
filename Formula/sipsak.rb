class Sipsak < Formula
  desc "SIP Swiss army knife"
  homepage "https://github.com/nils-ohlmeier/sipsak/"
  url "https://downloads.sourceforge.net/project/sipsak.berlios/sipsak-0.9.6-1.tar.gz"
  version "0.9.6"
  sha256 "5064c56d482a080b6a4aea71821b78c21b59d44f6d1aa14c27429441917911a9"

  bottle do
    cellar :any
    sha256 "ec6959b5778c091626354d80a76fcd96fb1c9ad62661818bca1a724d2e27f7b1" => :mojave
    sha256 "7590f9703c8c1a70bcc03274f278a398a2bc0d0259c4e7a7fb91c524ec4153ec" => :high_sierra
    sha256 "4725693dba5edcb68df030b63cb738795e96d29668bc9bf512ba8e2800ec862a" => :sierra
    sha256 "9f42a09240891ecd9aa62dea1dd75dc1c5362d2f946fefecf13ce975a6c05626" => :el_capitan
    sha256 "873d8cd50cce684ad55abbdf834157b4464c70877de9d1c37ad3c4ec9aaf6e10" => :yosemite
    sha256 "d70729739fcfe770fdfa997dc33cd04370a6cd2f6916e63adfed60473c4bfc55" => :mavericks
    sha256 "09d0961004d525dfc5f81bfe111884b401a09993fd83ff2f426016feb99607d4" => :mountain_lion
  end

  depends_on "openssl"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/sipsak", "-V"
  end
end
