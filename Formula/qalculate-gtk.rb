class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v2.8.1/qalculate-gtk-2.8.1.tar.gz"
  sha256 "d22a77ce0b480f3a6f7c1288eed1c7969d74bb4f1bd395f6a45335dae3f50115"

  bottle do
    sha256 "c56edef63d0ba67f92de167d82e596d3ab1bcbad8f522aa033fff5a26ed4a3d2" => :mojave
    sha256 "b0ef32346245a91e69f0b68db7643f2949a6d83fae7255268476b52b783fa2b1" => :high_sierra
    sha256 "54cec55a51392174ae3f124b609b1aadc18b8f5843a8923cde50d3e04da5255d" => :sierra
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
