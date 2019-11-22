class Residualvm < Formula
  desc "3D graphic adventure game interpreter"
  homepage "https://residualvm.org/"
  url "https://github.com/residualvm/residualvm/archive/0.3.1.tar.gz"
  sha256 "515b02129dd374bc9c0b732ddeaaaa3a342cc25ea0ea3c4ccf19141b5d362e1d"
  head "https://github.com/residualvm/residualvm.git"

  bottle do
    sha256 "34bd84a972a9c7c73e0c50794d28422919085cd6b46526aa897d5126ce20dd63" => :catalina
    sha256 "dec4dc6a4390ab934a4983188243edf8a0bdf6b965d1722f93dc944ed97effe7" => :mojave
    sha256 "de0c13e8d6e76d479b82497b9f8b653764c813eab695871aa1a8409d3914d860" => :high_sierra
  end

  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "glew"
  depends_on "jpeg-turbo"
  depends_on "libmpeg2"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl2"
  depends_on "theora"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-release",
                          "--enable-cloud",
                          "--enable-faad",
                          "--enable-flac",
                          "--enable-fluidsynth",
                          "--enable-libcurl",
                          "--enable-opengl-shaders",
                          "--with-sdl-prefix=#{Formula["sdl2"].opt_prefix}"
    system "make"
    system "make", "install"
    (share+"icons").rmtree
    (share+"pixmaps").rmtree
  end

  test do
    system "#{bin}/residualvm", "-v"
  end
end
