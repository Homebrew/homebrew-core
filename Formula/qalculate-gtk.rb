class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v2.8.2/qalculate-gtk-2.8.2.tar.gz"
  sha256 "cf924d3de4f5c70a95d83c35540fa6820fe3e19a49ce87fa1182e757246e29e9"

  bottle do
    cellar :any
    sha256 "b83640765c09ab534524b5a9e66e7f7109a5ce2d51e0dd41ec31583c191186a1" => :mojave
    sha256 "9a263641da3ba1072b30f8e8682a465d03aee7786d2fabc1e214d5561d8222c2" => :high_sierra
    sha256 "373a0de63d6a778cd7e8c381b929bfa2c13baae28bcb6027950f3f05d54cd22c" => :sierra
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
