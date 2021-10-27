class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "http://www.unixodbc.org/"
  url "http://www.unixodbc.org/unixODBC-2.3.9.tar.gz"
  mirror "https://fossies.org/linux/privat/unixODBC-2.3.9.tar.gz"
  sha256 "52833eac3d681c8b0c9a5a65f2ebd745b3a964f208fc748f977e44015a31b207"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "http://www.unixodbc.org/download.html"
    regex(/href=.*?unixODBC[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "460cf2165b1c047230b79f8c78c47b954a67d7dd64fafeb383923f11dd6d11ae"
    sha256 arm64_big_sur:  "66e4b186a19526e02782557afe6926d2cfb9f372e94cbcc387f531b122f510e0"
    sha256 monterey:       "762c9e183a9bebe5c44b2ad984cc87d730e2b316396e7260c0905290dbd32dca"
    sha256 big_sur:        "7e85c6cae69a18bc572ac63a624d44f5e1f71b84693cdf6acf165449b35f90b7"
    sha256 catalina:       "bd9ae8319552747572047c19a24ff3d55e3c59a51635ab799fd0959655d07459"
    sha256 mojave:         "e3b8eeab0c16a66f1aae4784e5248f46c1476460982113803d62840379116f07"
    sha256 x86_64_linux:   "1fbd8485269b6801167ff9ab353296796755ec3c6e8d9e8cab19ac17136bf92b"
  end

  depends_on "libtool"

  conflicts_with "libiodbc", because: "both install `odbcinst.h`"
  conflicts_with "virtuoso", because: "both install `isql` binaries"

  # fix issue with SQLSpecialColumns on ARM64
  # remove for 2.3.10
  # https://github.com/lurcher/unixODBC/issues/60
  # https://github.com/lurcher/unixODBC/pull/69
  patch :DATA

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

__END__
--- a/DriverManager/drivermanager.h
+++ b/DriverManager/drivermanager.h
@@ -1091,11 +1177,23 @@ void return_to_pool( DMHDBC connection );
 #define DM_SQLSPECIALCOLUMNS        72
 #define CHECK_SQLSPECIALCOLUMNS(con)    (con->functions[72].func!=NULL)
 #define SQLSPECIALCOLUMNS(con,stmt,it,cn,nl1,sn,nl2,tn,nl3,s,n)\
-                                    (con->functions[72].func)\
+                                    ((SQLRETURN (*) (\
+                                           SQLHSTMT, SQLUSMALLINT,\
+                                           SQLCHAR*, SQLSMALLINT,\
+                                           SQLCHAR*, SQLSMALLINT,\
+                                           SQLCHAR*, SQLSMALLINT,\
+                                           SQLUSMALLINT, SQLUSMALLINT))\
+                                    con->functions[72].func)\
                                         (stmt,it,cn,nl1,sn,nl2,tn,nl3,s,n)
 #define CHECK_SQLSPECIALCOLUMNSW(con)    (con->functions[72].funcW!=NULL)
 #define SQLSPECIALCOLUMNSW(con,stmt,it,cn,nl1,sn,nl2,tn,nl3,s,n)\
-                                    (con->functions[72].funcW)\
+                                    ((SQLRETURN (*) (\
+                                        SQLHSTMT, SQLUSMALLINT,\
+                                        SQLWCHAR*, SQLSMALLINT,\
+                                        SQLWCHAR*, SQLSMALLINT,\
+                                        SQLWCHAR*, SQLSMALLINT,\
+                                        SQLUSMALLINT, SQLUSMALLINT))\
+                                    con->functions[72].funcW)\
                                         (stmt,it,cn,nl1,sn,nl2,tn,nl3,s,n)
 
 #define DM_SQLSTATISTICS            73
