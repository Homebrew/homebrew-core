class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.11.0/qalculate-gtk-3.11.0.tar.gz"
  sha256 "eb2a0502e9c5e93b43d2b2c42608bbafd475d70caf236a51285fea606d9d3167"
  revision 1

  bottle do
    sha256 "9bda68dafd242f325e2db9c5175d92ccbc1cdd207b79d898f8dd2e568e922c9e" => :catalina
    sha256 "3d5c582b8d5b5ed7f673f615522b1efc4cbb21d2bea99e06c1a31598ac695617" => :mojave
    sha256 "ee6fba1fad472df1939c6d5b409e9ef9a97e9ab5a06a3211d4f3fcea3c4c332d" => :high_sierra
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
