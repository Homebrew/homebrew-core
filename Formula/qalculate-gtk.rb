class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.21.0/qalculate-gtk-3.21.0.tar.gz"
  sha256 "7927894cc09de2d5dde1ddee7e64ab372d926c812be4da216cf92d7658537595"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "1fbcd5ed4c1b1d15924264326453a1d86c0f46b57b932238f937c3701a2dd4fe"
    sha256 big_sur:       "fdb6bb89705df2243d33a68fb2587063ebecdbdf8f0305e3da08cbd605633387"
    sha256 catalina:      "30eddfe4485d0c1aac5767b2ceec66bfa4d97ec1e26948c5697245d3b63eab16"
    sha256 mojave:        "4ae51d31f6e30ea15741ab1dbb93234ac3dde2ea3f4ffa0229d460ac07a49384"
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
