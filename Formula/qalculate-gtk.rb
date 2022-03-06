class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v4.0.0/qalculate-gtk-4.0.0.tar.gz"
  sha256 "51f705737fe6defb6b57058ddd357ca1dd11af57655a90f9e41a40e8dbb9d81c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "beb7ce63f37ed90091ce6e532f6e0b5a8bd456ecd45f0168ddb56d1aa6a0172c"
    sha256 arm64_big_sur:  "c23118504c013f91448dd4adc9e71e5e3132c6cb16971aae9156b049d9f998d6"
    sha256 monterey:       "a12d3155d392672125b59f8cea3340da6fc1b457d7ef210174ab7fe8a2de639d"
    sha256 big_sur:        "268c069a300fed37259e2033fc80751488e9c15e8f51724bcc4509db7c94a650"
    sha256 catalina:       "bfdece419f5a09959d20d637704d51747bb23cd244b66650aef60bc88f144e72"
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
