class Residualvm < Formula
  desc "3D graphic adventure game interpreter"
  homepage "http://residualvm.org"
  url "https://downloads.sourceforge.net/project/residualvm/residualvm/0.2.1/residualvm-0.2.1-sources.tar.bz2"
  sha256 "cd2748a665f80b8c527c6dd35f8435e718d2e10440dca10e7765574c7402d924"
  revision 1
  head "https://github.com/residualvm/residualvm.git"

  bottle do
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
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl"
  depends_on "theora"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-release"
    system "make"
    system "make", "install"
    (share+"icons").rmtree
    (share+"pixmaps").rmtree
  end

  test do
    system "#{bin}/residualvm", "-v"
  end
end
