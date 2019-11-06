class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.5.0/qalculate-gtk-3.5.0.tar.gz"
  sha256 "9cbc391e95274fa5414ae7d0ba7d9a60456734a746337cac6bef9b8bc30b1e69"

  bottle do
    cellar :any
    sha256 "6aee505df9b81b716cafa5483d6be6f8bfeb15f2defdf75cddc94b805386b7f6" => :catalina
    sha256 "86e272b083083dd24273cf9fb29f48889de864b0c40f94cb45e574717a131fa3" => :mojave
    sha256 "c8df7440cdd50ec52d8d7fba273748fe8fbabda753b86ddb80da850b8e7f471f" => :high_sierra
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
