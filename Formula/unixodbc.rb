class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "http://www.unixodbc.org/"
  url "https://downloads.sourceforge.net/project/unixodbc/unixODBC/2.3.4/unixODBC-2.3.4.tar.gz"
  mirror "ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.4.tar.gz"
  sha256 "2e1509a96bb18d248bf08ead0d74804957304ff7c6f8b2e5965309c632421e39"

  bottle do
    rebuild 1
    sha256 "67d8a07e5abf3f964101d94911321271ebd755076f4a39f73657b826619b88df" => :high_sierra
    sha256 "b3117348129272e966e9fd3e37f29ccdffbf9a0dde9d8e2691a3185feaae92ff" => :sierra
    sha256 "78bb1bb4468cb34d0acf6566ecaad6535a9b77ff7a740bafd2ed91e1d7812c70" => :el_capitan
    sha256 "82f217f67f78a6dab125b77558e99f9ee18227f991ab8d842e881e83d0c7d917" => :yosemite
  end

  depends_on "libtool" => :run

  keg_only "Shadows system iODBC header files" if MacOS.version < :mavericks

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
