class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "http://www.unixodbc.org/"
  url "http://www.unixodbc.org/unixODBC-2.3.7.tar.gz"
  sha256 "45f169ba1f454a72b8fcbb82abd832630a3bf93baa84731cf2949f449e1e3e77"

  bottle do
    rebuild 1
    sha256 "d9f30688c0639d73b9e3a4b4b94d3679b2762e2cf0bff6b2ad64fcd175cc30ca" => :mojave
    sha256 "0b30b166c0e6bbd9df375a018d0f2a80b944617230b15531093d20eb015971e6" => :high_sierra
    sha256 "44407c41dc2c5cc58fcd2c254fa54ede75e7782b82567f4f1ba421d357203105" => :sierra
  end

  depends_on "libtool"

  conflicts_with "libiodbc", :because => "both install 'odbcinst.h' header"
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
