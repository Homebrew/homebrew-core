class Residualvm < Formula
  desc "3D graphic adventure game interpreter"
  homepage "https://residualvm.org/"
  url "https://github.com/residualvm/residualvm/archive/0.3.1.tar.gz"
  sha256 "515b02129dd374bc9c0b732ddeaaaa3a342cc25ea0ea3c4ccf19141b5d362e1d"
  head "https://github.com/residualvm/residualvm.git"

  bottle do
    sha256 "57c10afb5ac7574dc115498197d9d7219d522c4153f574247e59b3faed0462f7" => :catalina
    sha256 "0b47a9b302d06c18d28d89703a99e2e66bac92a49430c10f48832e0300a5858f" => :mojave
    sha256 "783c6c9e017d19eb2e41d95887a5af3fdeb74a649e9369a641bfc750d2552cb0" => :high_sierra
    sha256 "8281bb6898adfa48808f9d0217b6365918f3dc499dd026723be595644545a43b" => :sierra
    sha256 "35d2a278927c3f38e099581c5b8ef684c75adc84f2e8bfbc3eaa422738e195ea" => :el_capitan
    sha256 "1d8666ce740532b37383960334000dd2f935398dfcee9484885e5f5022612f10" => :yosemite
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
