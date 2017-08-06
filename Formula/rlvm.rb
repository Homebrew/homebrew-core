class Rlvm < Formula
  desc "RealLive interpreter for VisualArts games"
  homepage "http://www.rlvm.net/"
  url "https://github.com/eglaysher/rlvm/archive/release-0.14.tar.gz"
  sha256 "6d1717540b8db8aca1480ebafae3354b24e3122a77dd2ee81f4b964c7b10dcc0"
  revision 3
  head "https://github.com/eglaysher/rlvm.git"

  bottle do
    cellar :any
    sha256 "15224d715d68ff0b13400bfb019854468fb30ecfb3b79331f3189f2b2f0b6e0c" => :sierra
    sha256 "38d05e55edc9ec41093a99068a024cf3bcb2103e15836fb998e56e2d13e5ffcc" => :el_capitan
    sha256 "c898946954df941a70c06bc2bce4dd59fd8f508a8b84f8da03af829e47fed671" => :yosemite
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
    url "https://github.com/eglaysher/rlvm/commit/668863d2222b962ee8e7d9829e972ef05c990302.diff?full_index=1"
    sha256 "4837f691a31d927cd2d6547d3c04c86de30cec0daacc38e3f6940bbdad954e98"
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
