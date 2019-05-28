class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.2.0/qalculate-gtk-3.2.0.tar.gz"
  sha256 "b9374d6c253418c8666db29102ff7525b9785a123318702a55c422b70c1b36b5"

  bottle do
    cellar :any
    sha256 "76f5fd40dce34ca93a28d5385c10f9e2a91a82c67929462ae6f8ca69f4668325" => :mojave
    sha256 "a120b7533d3bd7c61f049639aa76080d7bd432a6762c723e6c1986580bfb33e8" => :high_sierra
    sha256 "27e0f4cc28341e9786fd4edb3adecd20814bdfe16780d35a37275fce9d6e780e" => :sierra
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
