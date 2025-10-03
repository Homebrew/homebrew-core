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
    rebuild 1
    sha256 arm64_tahoe:   "7c9526b441435001124460466ddd9c036cc494d894b9131a2c1e03f3a0b4dc86"
    sha256 arm64_sequoia: "e319fd6f83f15c3c96c570c4f9782ad0d964181a98da712905b94f589dddd921"
    sha256 arm64_sonoma:  "f0363503a99f6f4ffa64b12eb5c99612250af7964c8be8906d3156a798065531"
    sha256 sonoma:        "b033f17443c5fc20d3af8f904b90a3bf9bdf668efbfb8bdf0bac5b1bfc3ebc64"
    sha256 arm64_linux:   "151b0f1ec0f4cc526c338542ce1a292ccc923e09c7f3f23bd178794a5b93dcb7"
    sha256 x86_64_linux:  "5a7ce1eeb9ce55f3a61a9a9ae16123ad02bf67462abdd49d73a42058cab5db01"
  end

  depends_on "libtool"

  conflicts_with "virtuoso", because: "both install `isql` binaries"

  # These conflict with `libiodbc`, which is now keg-only.
  link_overwrite "include/odbcinst.h", "include/sql.h", "include/sqlext.h",
                 "include/sqltypes.h", "include/sqlucode.h"
  link_overwrite "lib/libodbc.a", "lib/libodbc.so"

  # Fix segfault where `dst` is passed to `memcpy` instead of `*dst`
  # https://github.com/lurcher/unixODBC/commit/97add92e08ed42102234055d55e098e1c8e5c1c0
  patch do
    url "https://github.com/lurcher/unixODBC/commit/97add92e08ed42102234055d55e098e1c8e5c1c0.patch?full_index=1"
    sha256 "1cc28bbc3fcc4fc170c7b806ca9c1f69c9ecb0c599c7a7a7598da202eaa797e5"
  end

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
