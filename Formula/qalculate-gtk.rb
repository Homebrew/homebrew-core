class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.10.0/qalculate-gtk-3.10.0.tar.gz"
  sha256 "e4c88a9d0750fdec863f287c82893ecb4349532cfb378d2cc690422b4584d65e"

  bottle do
    sha256 "6d337c1307e5db1d4ffa433eaf06d0b69111919d029ce89eb25620f6a0b2d02a" => :catalina
    sha256 "7f5144110580eb2e62449df7174803797aba9f14737490799436ad1d8e0be749" => :mojave
    sha256 "a87203f6139a2ad31ac672bf27459b85a1d841268463b9ff9f3d33b4b87f5b19" => :high_sierra
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
