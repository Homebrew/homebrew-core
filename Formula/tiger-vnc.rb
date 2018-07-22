class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "http://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/v1.9.0.tar.gz"
  sha256 "f15ced8500ec56356c3bf271f52e58ed83729118361c7103eab64a618441f740"

  bottle do
    sha256 "d752a41b65a44ccdbccc7fb28b8a3c2a7d79d789bbbcef5f8afc8ee3258ef247" => :high_sierra
    sha256 "56dfa034d853ad90172c4768cea4f2c5c943539d31bc474cb1fdd49ef05ab726" => :sierra
    sha256 "37cf3c2d2d7d7624f0b2c16851a049c86fa59832921db81d6e8e55e28b759851" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gnutls" => :recommended
  depends_on "jpeg-turbo"
  depends_on "gettext"
  depends_on "fltk"
  depends_on :x11

  def install
    turbo = Formula["jpeg-turbo"]
    args = std_cmake_args + %W[
      -DJPEG_INCLUDE_DIR=#{turbo.include}
      -DJPEG_LIBRARY=#{turbo.lib}/libjpeg.dylib
      .
    ]
    system "cmake", *args
    system "make", "install"
  end
end
