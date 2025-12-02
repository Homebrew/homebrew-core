class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "https://www.unixodbc.org/"
  url "https://www.unixodbc.org/unixODBC-2.3.14.tar.gz"
  mirror "https://fossies.org/linux/privat/unixODBC-2.3.14.tar.gz"
  sha256 "4e2814de3e01fc30b0b9f75e83bb5aba91ab0384ee951286504bb70205524771"
  license all_of: [
    "LGPL-2.1-or-later", # libraries
    "GPL-2.0-or-later",  # programs
  ]

  livecheck do
    url "https://www.unixodbc.org/download.html"
    regex(/href=.*?unixODBC[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "16b4c2a9d565749bae947c75a100ec4628e57c427af5b542593f67474077b3cb"
    sha256 arm64_sequoia: "e1522105d20545743c713e90c17bf6393d7a829ec01137ec0d6942bbc04ea2d2"
    sha256 arm64_sonoma:  "39f022a55a502b3b1d46769705cc46c4aa9f9206b902558ed56cd47aab3d54d8"
    sha256 sonoma:        "6fc56b53e2abd5b38ed655c2c32caae95753e6b6f5a9fe0a10c4b760a3974d2e"
    sha256 arm64_linux:   "8e6e9979f6e88ae812222d215688d5b044e25f3182a70e3fbeec3ca07dd9f3d9"
    sha256 x86_64_linux:  "3f04884aa241e341fea833df1fcb51ec7b181e5a75ff4a7b86ca87dc4c7a24dd"
  end

  depends_on "libtool"

  conflicts_with "virtuoso", because: "both install `isql` binaries"

  # These conflict with `libiodbc`, which is now keg-only.
  link_overwrite "include/odbcinst.h", "include/sql.h", "include/sqlext.h",
                 "include/sqltypes.h", "include/sqlucode.h"
  link_overwrite "lib/libodbc.a", "lib/libodbc.so"

  def install
    system "./configure", "--disable-gui",
                          "--enable-static",
                          "--sysconfdir=#{etc}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"odbcinst", "-j"
  end
end
