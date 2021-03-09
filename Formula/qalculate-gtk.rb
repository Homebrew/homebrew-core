class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  # NOTE: Please keep these values in sync with libqalculate.rb when updating.
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.17.0/qalculate-gtk-3.17.0.tar.gz"
  sha256 "b95f4be3c6fd883dec280a92d46b4678f8a7de2e5b654344246bb9d87695626b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "2cf0fdd6bb6d3aa123cf69cf896c363aadfad7061569f64d1642f7d07e7794cf"
    sha256 big_sur:       "6da6d042cfcee11b68629ef29c8a27ab107a416923e626e5c9f2eadb7cab2ca7"
    sha256 catalina:      "3b29ddcec9f5c65568af677d1a8ae2b2e9c4195f37ba28255debe3430e8bac0f"
    sha256 mojave:        "31dfae1024cd003580e8a97fdde32672c900c946f6179429dac06bbd84e2debf"
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
