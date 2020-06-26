class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.11.0/qalculate-gtk-3.11.0.tar.gz"
  sha256 "eb2a0502e9c5e93b43d2b2c42608bbafd475d70caf236a51285fea606d9d3167"

  bottle do
    sha256 "2543fcc26bf642d9609164f1632edc4279cfa543476083b0f5296a2b50136333" => :catalina
    sha256 "1068ff26de3b8e2e547194d24f1e85d7a2218ed954b632af79233c57f79b56d8" => :mojave
    sha256 "f0457ede3e9f4861917fc507e5a94d26e1bd00dfbd5f9c295373732fc7111c5a" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "libqalculate"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalculate-gtk", "-v"
  end
end
