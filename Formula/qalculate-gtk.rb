class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  # NOTE: Please keep these values in sync with libqalculate.rb when updating.
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.20.1/qalculate-gtk-3.20.1.tar.gz"
  sha256 "3985766a7b8977a0d1f94b807ea66e388ed29192185394c9ccc7b5733e4ce136"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "81401e1e322a8b0553b767e151b13ccfedb731d896a9517c64ed447e79ded773"
    sha256 big_sur:       "0b1a453cca7a5307ee5284a3db88c0b74964ba05e62414f3e2cd6766f6b7e74c"
    sha256 catalina:      "853af755a3971e43eb4323ab5b71c85a440bf2b0bf3e3feaea289c1b91efa8f8"
    sha256 mojave:        "9a9565c1e9443448db8357e9d46f7dd8be72284c33a61b1fbeac8447eec58fcd"
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
