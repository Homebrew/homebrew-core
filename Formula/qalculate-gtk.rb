class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.7.0/qalculate-gtk-3.7.0.tar.gz"
  sha256 "3d83c2abf3d32ef334f7d290b178757b281407aa4f93c9a0131f4b70cfa0dfa7"

  bottle do
    cellar :any
    sha256 "e9d7201a04dd15878df1d2085b96741960bf606d12419d5585c5f643eb2196f1" => :catalina
    sha256 "01f95e1b67aec661706877e07e6eca429e142275ce8f676e4011c875de030777" => :mojave
    sha256 "928e5e48953583366db0ef5308aa999fcc0985ed7ae6a17c8fecd3a071a6b55c" => :high_sierra
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
