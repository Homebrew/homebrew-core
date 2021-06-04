class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  # NOTE: Please keep these values in sync with libqalculate.rb when updating.
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.19.0/qalculate-gtk-3.19.0.tar.gz"
  sha256 "9c060a9a0da9717e7c66acbfd3dfc8c556d731d83448195658219c1b4d5b21cc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "ac0fc868111cd78080b625985001ebe8ba8aea68c740563bfa9f1f145c951d1f"
    sha256 big_sur:       "ed3178d2c81a01b57bfa9f5cc0f2479c415f1017c6c2565ae9d14480e0c3e030"
    sha256 catalina:      "6e0d5b4ec633642c48eb63181e6a4e599a818770f9ede968f12d69a7143e8f74"
    sha256 mojave:        "5d7e4963f7d1e8f541e17a6f33115dac09ba322678074cd41c75263aa163d710"
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
