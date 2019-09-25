class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.4.0/qalculate-gtk-3.4.0.tar.gz"
  sha256 "6ff0c1e9dd02fc4239569ca78bd3f5b8502676c9a08473e62975da22af97c271"

  bottle do
    cellar :any
    sha256 "13f1c52eafa283201d8a4087590e8a6053255e1e39ef287d2e7972e5ca6204df" => :mojave
    sha256 "b8a32dd4fa0d7895965895a9ad47e88e2114a521444e1b10b9f67ec1df99c5ed" => :high_sierra
    sha256 "9be9559d57bf2e7e93d35d59d6d517762b8b42f1d168f3a8f0c7e52d7c344838" => :sierra
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
