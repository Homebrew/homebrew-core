class Vde < Formula
  desc "Ethernet compliant virtual network"
  homepage "https://github.com/virtualsquare/vde-2"
  url "https://github.com/virtualsquare/vde-2/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "a7d2cc4c3d0c0ffe6aff7eb0029212f2b098313029126dcd12dc542723972379"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/virtualsquare/vde-2.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "d0db1dd42cba0815587a9919f242dc7708a6b450fbb390fedb7be0f43df8691d"
    sha256 arm64_monterey: "e4d5fbb28025cb50acf1a1c8e11a2aeb33e1324b42b49d7f3709fab81a708c55"
    sha256 arm64_big_sur:  "d504166629275fb173304ee78b134a6c5b5eabba65c054f2fede1949204382dd"
    sha256 monterey:       "c043ada3aefd2f0a9eeb6f60db1003cc6b340da282d7fb93d940be47aac9fc6b"
    sha256 big_sur:        "f634d3558c44876138a229f06554ab603b31e412a03c049d96f6c3616e579729"
    sha256 catalina:       "711f5b171e033b92505178b35a324a5c21e806ed5054a92ef02f26b3a38a760e"
    sha256 mojave:         "4f880ec345fe86fdfcfc53468c7c24d160261a17ee71a289ea3357a47b71416c"
    sha256 high_sierra:    "79ee1bbcca1f873e3740db401c1f8735f2366e785b56fcf6e0e4140e9048333b"
    sha256 x86_64_linux:   "d0ecff46c013cef96a1a32d6fd45d415a32dbd300932d2eb352f969445ce251c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--install"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "vde_switch", "-v"
  end
end
