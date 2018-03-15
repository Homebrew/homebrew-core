class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://live.gnome.org/Zenity"
  url "https://download.gnome.org/sources/zenity/3.28/zenity-3.28.0.tar.xz"
  sha256 "5e588f12b987db30139b0283d39d19b0fd47cab87840cc112dfe61e592826df8"

  bottle do
    sha256 "13dfaf6dfc6e6a1a9ca48611d07ed9ee52d0443f6ac44f65582c97ed55fbb93b" => :high_sierra
    sha256 "10c4cf42ba7e5e6db0c8bfb9042ed56e672cbe559d30f369f9317f816f138684" => :sierra
    sha256 "1621aa813f8d0a7ccda22fa94a20d0a982584598945a8abca1cfcd45d2b0eb6b" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "itstool" => :build
  depends_on "gtk+3"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"zenity", "--help"
  end
end
