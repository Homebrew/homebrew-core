class Residualvm < Formula
  desc "3D graphic adventure game interpreter"
  homepage "http://residualvm.org"
  url "https://downloads.sourceforge.net/project/residualvm/residualvm/0.2.1/residualvm-0.2.1-sources.tar.bz2"
  sha256 "cd2748a665f80b8c527c6dd35f8435e718d2e10440dca10e7765574c7402d924"
  head "https://github.com/residualvm/residualvm.git"

  bottle do
    revision 1
    sha256 "ae156d7f7507a6469fa6538d5e0adc056baaf97341ed3a913c4bd0c8d518ba25" => :yosemite
    sha256 "f42ea636d726f4c74066634d4b198296861beb62a8476f14e459168d25ea8b24" => :mavericks
    sha256 "88e0730c81f130ed196de58ab791610f7219837797a343b1ed736ace0235f25b" => :mountain_lion
  end

  option "with-all-engines", "Enable all engines (including broken or unsupported)"
  option "with-safedisc", "Enable SafeDisc decryption for Myst III"

  depends_on "sdl"
  depends_on "libvorbis" => :recommended
  depends_on "mad" => :recommended
  depends_on "flac" => :recommended
  depends_on "libmpeg2" => :optional
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "theora" => :recommended
  depends_on "faad2" => :recommended
  depends_on "fluid-synth" => :recommended
  depends_on "freetype" => :recommended

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-release
    ]
    args << "--enable-all-engines" if build.with? "all-engines"
    args << "--enable-safedisc" if build.with? "safedisc"
    system "./configure", *args
    system "make"
    system "make", "install"
    (share+"icons").rmtree
    (share+"pixmaps").rmtree
  end

  test do
    system "#{bin}/residualvm", "-v"
  end
end
