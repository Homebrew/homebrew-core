class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "http://www.unixodbc.org/"
  url "http://www.unixodbc.org/unixODBC-2.3.11.tar.gz"
  mirror "https://fossies.org/linux/privat/unixODBC-2.3.11.tar.gz"
  sha256 "d9e55c8e7118347e3c66c87338856dad1516b490fb7c756c1562a2c267c73b5c"
  license "LGPL-2.1-or-later"

  livecheck do
    url "http://www.unixodbc.org/download.html"
    regex(/href=.*?unixODBC[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "9f60dd0a90ce369c86823f41f5571517ec7865f8af19c09eff91c74a10f0ee93"
    sha256 arm64_big_sur:  "68abc410c8a428b9b9e005ad8edded59216be43fa430b98b91c2acbeff2a1098"
    sha256 monterey:       "ef77c3b526f13cb38067029cdef82d5a8e26f367c5af6ac0d3063da9856179f0"
    sha256 big_sur:        "9fc17e26134678df109afa873bad1bfd67b2c7a6f2eeb6e10a1600d26942f764"
    sha256 catalina:       "18bead9d30a91f45175713a31064aea78bb1eb47eb4d2b92ace4a7001841cbee"
    sha256 x86_64_linux:   "2bbd056082d6cb6e85f854cc6c609ad91ced02671e3a08ba29e26b1547b4e035"
  end

  depends_on "libtool"

  conflicts_with "libiodbc", because: "both install `odbcinst.h`"
  conflicts_with "virtuoso", because: "both install `isql` binaries"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-static",
                          "--enable-gui=no"
    system "make", "install"
  end

  test do
    system bin/"odbcinst", "-j"
  end
end
