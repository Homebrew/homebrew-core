class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "http://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/v1.8.0.tar.gz"
  sha256 "9951dab0e10f8de03996ec94bec0d938da9f36d48dca8c954e8bbc95c16338f8"

  bottle do
    sha256 "da4b58cfb0117ac7f2c4a81cba70bb653f8404d6bc8ff02e5320e05f02904ebb" => :sierra
    sha256 "ffeabdeebdeadb9837915070a9730a93fb5bfc8bd69dd8719e2c15d6eb103e64" => :el_capitan
    sha256 "a719884736ffa0fa5ecf99bda2df2afde53897cb08115399a729fbe73a38513a" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "gnutls" => :recommended
  depends_on "jpeg-turbo"
  depends_on "gettext"
  depends_on "fltk"
  depends_on :x11

  def install
    # Fix "redefinition of 'kVK_RightCommand' as different kind of symbol"
    # Reported 16 May 2017 https://github.com/TigerVNC/tigervnc/issues/459
    if DevelopmentTools.clang_build_version >= 800
      inreplace "vncviewer/cocoa.mm", "const int kVK_RightCommand = 0x36;", ""
    end

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
