class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "http://www.unixodbc.org/"
  url "http://www.unixodbc.org/unixODBC-2.3.6.tar.gz"
  sha256 "88b637f647c052ecc3861a3baa275c3b503b193b6a49ff8c28b2568656d14d69"

  bottle do
    sha256 "df1bc9fd3d8f42f9c28be234ef8b088428e593ebb3cdea770eff46bbbabed3b3" => :high_sierra
    sha256 "d3ed41256b2d4cf0e6dc827aa9a99af06db96d870cb99bfd9f89eef519381d0d" => :sierra
    sha256 "4000a04bcd306d0ce55cacff24bc6a6e3592c20be42c0ce5ce3a9171a00cf5f2" => :el_capitan
  end

  depends_on "libtool"

  keg_only "shadows system iODBC header files" if MacOS.version < :mavericks

  conflicts_with "virtuoso", :because => "Both install `isql` binaries."

  def install
    # Fixes "sed: -e: No such file or directory"
    # Reported 22 Mar 2018 to nick AT unixodbc DOT org
    inreplace "exe/Makefile.in", "@sed -i -e", "@sed -i '' -e"

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
