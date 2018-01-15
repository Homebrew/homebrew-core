class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "http://www.unixodbc.org/"
  url "http://www.unixodbc.org/unixODBC-2.3.5.tar.gz"
  sha256 "760972e05cc6361aee49d676fb7da8244e0f3a225cd4d3449a951378551b495b"

  bottle do
    sha256 "f4d80627b3213e4839ec71fb61b752c30feae0b3d739c8a5ffd4a080a83d9f9f" => :high_sierra
    sha256 "9bb178235eccd5648b2659b5a958c521ab3ff8203775d697406da5200e27b52d" => :sierra
    sha256 "dc8896da05aaa244c52d69052d949fbe7174df92300d36371aac58ecd7233c4f" => :el_capitan
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
