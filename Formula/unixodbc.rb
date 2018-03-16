class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "http://www.unixodbc.org/"
  url "http://www.unixodbc.org/unixODBC-2.3.5.tar.gz"
  sha256 "760972e05cc6361aee49d676fb7da8244e0f3a225cd4d3449a951378551b495b"
  revision 1

  bottle do
    sha256 "df1bc9fd3d8f42f9c28be234ef8b088428e593ebb3cdea770eff46bbbabed3b3" => :high_sierra
    sha256 "d3ed41256b2d4cf0e6dc827aa9a99af06db96d870cb99bfd9f89eef519381d0d" => :sierra
    sha256 "4000a04bcd306d0ce55cacff24bc6a6e3592c20be42c0ce5ce3a9171a00cf5f2" => :el_capitan
  end

  depends_on "libtool" => :run

  keg_only "shadows system iODBC header files" if MacOS.version < :mavericks

  conflicts_with "virtuoso", :because => "Both install `isql` binaries."

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
