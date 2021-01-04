class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  # NOTE: Please keep these values in sync with libqalculate.rb when updating.
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.16.0/qalculate-gtk-3.16.0.tar.gz"
  sha256 "79cbdb9705921cbe5fe9593fb798cb68c455596bc20584c6d4c930c28137655f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 "52ad7189e1a9e1b24cc072c807796f0b6f31eff42dbb7cb2202dbff4a65e358f" => :big_sur
    sha256 "3131939575ad77dfdd4d69dca9455b4ec64d8bb697d93835654b47c7144fd067" => :arm64_big_sur
    sha256 "d159b4287212ebf82c9f699dd886fcf94712454c3079e57c7c6bd34c99d28895" => :catalina
    sha256 "2de05c4349f359fbba723e26a13a9f8268ce9e8da907418a977b3c7fd08bcb77" => :mojave
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
