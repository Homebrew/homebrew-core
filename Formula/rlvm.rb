class Rlvm < Formula
  desc "RealLive interpreter for VisualArts games"
  homepage "http://www.rlvm.net/"
  url "https://github.com/eglaysher/rlvm/archive/release-0.14.tar.gz"
  sha256 "6d1717540b8db8aca1480ebafae3354b24e3122a77dd2ee81f4b964c7b10dcc0"
  revision 1
  head "https://github.com/eglaysher/rlvm.git"

  bottle do
    cellar :any
    sha256 "42c29a5cf55b9198679dd4a0c61240615f16ef1c6ddd56bd0d338caa5a84fd53" => :el_capitan
    sha256 "cc4ce80b629c71ab86ad3b5a277984ed28df256f2d8f56f2f74a47fa3645c9da" => :yosemite
    sha256 "3c8051c72de57b00a29f8f0050160e95b20d1a73e817d1c8ca975157c21df62e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glew"
  depends_on "jpeg"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl"
  depends_on "sdl_image"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"

  # Fix missing system header after boost update
  # https://github.com/eglaysher/rlvm/issues/76
  patch do
    url "https://github.com/eglaysher/rlvm/commit/668863d2222b962ee8e7d9829e972ef05c990302.diff"
    sha256 "048bb7a3794a7b3eccb3976e6f61e6f250e14fa37c8ac79a52b4d231612730a4"
  end

  def install
    inreplace "SConstruct" do |s|
      s.gsub! /("z")/, '\1, "bz2"'
      s.gsub! /(CheckForSystemLibrary\(config, library_dict), subcomponents/, '\1, []'
      s.gsub! "jpeglib.h", "jconfig.h"
      s.gsub! /(msgfmt)/, "#{Formula["gettext"].bin}/\\1"
    end
    inreplace "SConscript.cocoa" do |s|
      s.gsub! /(static_env\.ParseConfig)\("sdl-config --static-libs", MergeEverythingButSDLMain\)/, '\1("pkg-config --libs sdl SDL_image SDL_mixer SDL_ttf freetype2").Append(FRAMEWORKS=["OpenGL"])'
      s.gsub! /(full_static_build) = True/, '\1 = False'
    end
    scons "--release"
    prefix.install "build/rlvm.app"
    bin.write_exec_script "#{prefix}/rlvm.app/Contents/MacOS/rlvm"
  end
end
