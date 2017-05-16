class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "http://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/v1.8.0.tar.gz"
  sha256 "9951dab0e10f8de03996ec94bec0d938da9f36d48dca8c954e8bbc95c16338f8"

  bottle do
    sha256 "427af0dff8bae2e2720f0c6dea41d54de8eb8e5549ae77faab3110a9366858a5" => :sierra
    sha256 "aba36a55571b32322bcd94cffce43eb5760bd54fa2000d68c3b968c2d9f0f161" => :el_capitan
    sha256 "b7def4172a88768e2e84df9931138e13401a81913a644f25a72ab43f7ba1f6ae" => :yosemite
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
