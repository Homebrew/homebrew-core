class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "http://www.unixodbc.org/"
  url "http://www.unixodbc.org/unixODBC-2.3.5.tar.gz"
  sha256 "760972e05cc6361aee49d676fb7da8244e0f3a225cd4d3449a951378551b495b"

  bottle do
    rebuild 2
    sha256 "ee4a4a339f04afbcea6f2d3d4d30e82c5d1a25a29bfbdcfcecfea865dd6ca2e8" => :high_sierra
    sha256 "f8e46488ccc480251051490a55bebb44cf95c90c0ee334857c81440c912ba25e" => :sierra
    sha256 "6adc0803981df524dc7a06618920e9d4972ebb077bda3f14c20f50705e63824a" => :el_capitan
  end

  depends_on "libtool" => :run

  keg_only "shadows system iODBC header files" if MacOS.version < :mavericks

  conflicts_with "virtuoso", :because => "Both install `isql` binaries."

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-static",
                          "--enable-gui=no"
    system "make", "install"
  end

  test do
    system bin/"odbcinst", "-j"
  end
end
