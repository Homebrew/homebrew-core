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
    sha256 arm64_ventura:  "4c0380e01085731950092d3fdbcb24865abcb7745cbb318759e21d77e14c2fa1"
    sha256 arm64_monterey: "41252118b5c049b7fb24be4d68aa0efd821d1b263db205b6b8395d538acdebbc"
    sha256 arm64_big_sur:  "d7c4effd78343a0e35e1ed173321299393132c84d383b34dacaa82abb09bfbcc"
    sha256 ventura:        "49e5a8977f4354a46597f38c61ce6f4c135b78c5d64b1909f90092ea379a0d8c"
    sha256 monterey:       "a4d5de6d53870f610840a88bd31c0d0442bc3580068f9330207ab8e0488fa523"
    sha256 big_sur:        "7c2e9b5e3e8b9e082afa7d669d0b073897fd30ebcc3ec566a2fa38fd63369087"
    sha256 catalina:       "c398fc445679a3619a8e602444963a4e46e9302a1813c192ac42d9b6cc2d7e63"
    sha256 x86_64_linux:   "e8d1c01d05e821f0e4aa4aa65f104266ed16331a3e39ae72071bbe0eaec03ea0"
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
