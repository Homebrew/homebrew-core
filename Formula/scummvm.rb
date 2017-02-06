class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://www.scummvm.org/frs/scummvm/1.9.0/scummvm-1.9.0.tar.xz"
  sha256 "2417edcb1ad51ca05a817c58aeee610bc6db5442984e8cf28e8a5fd914e8ae05"
  head "https://github.com/scummvm/scummvm.git"

  bottle do
    sha256 "e0886c043e7823f4123605721b72faf0fab35003183000fec6aa14ec86e3b6f7" => :sierra
    sha256 "1ccd12dee162c5be09ee8d0328bdd239897c746036e2bf98564ce349f70ebe59" => :el_capitan
    sha256 "c116f470d6ed19dacd261f27c7f00ab9e34b2398eb3aa48355cc7e1e000214a8" => :yosemite
  end

  option "with-all-engines", "Enable all engines (including broken or unsupported)"

  depends_on "sdl2"
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
    system "./configure", *args
    system "make"
    system "make", "install"
    (share+"pixmaps").rmtree
    (share+"icons").rmtree
  end

  test do
    system "#{bin}/scummvm", "-v"
  end
end
