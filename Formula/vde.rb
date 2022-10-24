class Vde < Formula
  desc "Ethernet compliant virtual network"
  homepage "https://github.com/virtualsquare/vde-2"
  url "https://github.com/virtualsquare/vde-2/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "a7d2cc4c3d0c0ffe6aff7eb0029212f2b098313029126dcd12dc542723972379"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  head do
    url "https://github.com/virtualsquare/vde-2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "wolfssl"

  def install
    system "autoreconf", "--install"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "vde_switch", "-v"
  end
end
