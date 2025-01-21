class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "https://www.unixodbc.org/"
  url "https://www.unixodbc.org/unixODBC-2.3.12.tar.gz"
  mirror "https://fossies.org/linux/privat/unixODBC-2.3.12.tar.gz"
  sha256 "f210501445ce21bf607ba51ef8c125e10e22dffdffec377646462df5f01915ec"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.unixodbc.org/download.html"
    regex(/href=.*?unixODBC[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "d117e16a10d134bc961f57c345296a7279f40376ab626dfa41777bf4cb4e116a"
    sha256 arm64_sonoma:   "4984c5ec2cd0ddc6393cfd60e42bc5748e3dc173750b74b2113de9b17c864c9a"
    sha256 arm64_ventura:  "b2d0036483c00d1f3e12b90e288d18b1714ee1b6e95de4d443c0b1101657bfba"
    sha256 arm64_monterey: "42752ba1f8be08b3aad93ab465731441911b0b2b6e3af687bd7cc5de0996de49"
    sha256 arm64_big_sur:  "82de868a1e06efd888aaef1a4b4867aa09f1e8ebb59de5ffe926f70c46f30399"
    sha256 sonoma:         "626e41606a2ff39516f08affe1c8e2f5396810a15adc7081b574a117e68a3bf1"
    sha256 ventura:        "362a801fa9dec4ee99daab0d9d6926fee4ca2ad7191677dbee1b564852964ddd"
    sha256 monterey:       "947aa88dde2ed452e05e9ef37aca672aea40165cd6d748cc8839609f9d7d4141"
    sha256 big_sur:        "704e008bba860d3baecd0ad178c82b8c59e0eb9b05161d908154723eabbd420d"
    sha256 x86_64_linux:   "7f8a5881a0827b6381d3619d681849d72471bd8f9ad9e836793d3216bee77fe4"
  end

  depends_on "libtool"

  conflicts_with "virtuoso", because: "both install `isql` binaries"

  # These conflict with `libiodbc`, which is now keg-only.
  link_overwrite "include/odbcinst.h", "include/sql.h", "include/sqlext.h",
                 "include/sqltypes.h", "include/sqlucode.h"
  link_overwrite "lib/libodbc.a", "lib/libodbc.so"

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
