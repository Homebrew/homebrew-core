class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  # NOTE: Please keep these values in sync with libqalculate.rb when updating.
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.18.0/qalculate-gtk-3.18.0.tar.gz"
  sha256 "3e727087877c7c367c223948d8ed807fd0bbc19386dd9f6f4741c213cd6d3311"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "3409af9645fa60159a69763606867a92ebb5ff4746f8047b343eb59042190a31"
    sha256 big_sur:       "ce12ad219fd5be302683718fcb07e2d66cf18ce9d85d41260b6dee8ba3172f4f"
    sha256 catalina:      "7ffaefe9864f934a4c44f46694919ca5a775919e3521d7232bd98a348acbc6de"
    sha256 mojave:        "6709830eadea1a24eb5cdd648edf1d5f2e331af9dafb927e2e8c6dd279baad2d"
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
