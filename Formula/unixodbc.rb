class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "http://www.unixodbc.org/"
  url "https://downloads.sourceforge.net/project/unixodbc/unixODBC/2.3.4/unixODBC-2.3.4.tar.gz"
  mirror "ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.4.tar.gz"
  sha256 "2e1509a96bb18d248bf08ead0d74804957304ff7c6f8b2e5965309c632421e39"

  bottle do
    sha256 "6fc7f4324ab8aaffdbe6eb2d45d9241a36645e5cb50200d417525d6bb901a677" => :sierra
    sha256 "a902055dc3ca4fbda0f26f5463cf971c1f80d13028ba8a7b2631823c8c84782b" => :el_capitan
    sha256 "91c8778727b1d8d5d2f2b0b21d25f3c8ff2f5221ec38231d06c54bbc75684f32" => :yosemite
    sha256 "f968a389218dde09820ce6d7278bcd521d7fb43e27f186541a8bfc538ff8ead6" => :mavericks
  end

  keg_only "Shadows system iODBC header files" if MacOS.version < :mavericks

  option :universal

  conflicts_with "virtuoso", :because => "Both install `isql` binaries."

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gui=no"
    system "make", "install"
  end

  test do
    system bin/"odbcinst", "-j"
  end
end
