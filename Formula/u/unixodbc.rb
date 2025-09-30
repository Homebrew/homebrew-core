class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "https://www.unixodbc.org/"
  url "https://www.unixodbc.org/unixODBC-2.3.13.tar.gz"
  mirror "https://fossies.org/linux/privat/unixODBC-2.3.13.tar.gz"
  sha256 "119afef5f4cb04e780ca6cf763265b9fb2b99c4c11349a3f9cab14069d2c7c2b"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.unixodbc.org/download.html"
    regex(/href=.*?unixODBC[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ca79032ddd8290b1cd9e9943911659ba2cfd4adda184fe81338b23a6ec1a680c"
    sha256 arm64_sequoia: "32d4bb10a53c451f4bf5c7c814a0350c82b3a6abc764481670521d1d9d166484"
    sha256 arm64_sonoma:  "03d6e6955edb57f13ed650cc29081f5428a943488e22ce51fc52b255d233292d"
    sha256 sonoma:        "fcd2cb6616f55a2706d1870c7d8117b46c718ea93c926e091746aeca5e7b48b5"
    sha256 arm64_linux:   "ffd1aebf4638c5a5be04bdd3d989eeaaffe366ebc2dceaeed9ed215050d96853"
    sha256 x86_64_linux:  "f61d1f1b5fe59f5e3205e94f3fe434a34043e7fd48b6c24b47c066b7e1d4042c"
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
