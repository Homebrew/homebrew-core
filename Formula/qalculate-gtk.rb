class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.12.1/qalculate-gtk-3.12.1.tar.gz"
  sha256 "1be087dace97c96c94cd0a032be103d8506001919a0ecc1cdd222445f5708596"
  license "GPL-2.0"

  bottle do
    sha256 "e9737908a26bf281a502ff2b0e7e34dac6c093c221693916d1c40fa2324f7137" => :catalina
    sha256 "b4b362c95d1511237a28d2a4c3a1a5e014184105e5f631bc84765bc35bf1509f" => :mojave
    sha256 "4e3fc920f38900616d7e2a909bcc2caff796907833bea7fd6f2c290777901487" => :high_sierra
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
