class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.11.0/qalculate-gtk-3.11.0.tar.gz"
  sha256 "eb2a0502e9c5e93b43d2b2c42608bbafd475d70caf236a51285fea606d9d3167"

  bottle do
    sha256 "3167c17fc2d4d09d0c65f02017af6580303313809a85e2915b860c8b34fc621b" => :catalina
    sha256 "2f7b251548f680ab1d45d00360f69cf5d0d06cc7887fc1a0bbe85d3d7fba04b6" => :mojave
    sha256 "c6e80c1062e9028e8076b6038f3485ceabb83aa4c00ec1f10d09829ca6d89eda" => :high_sierra
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
