class Sng < Formula
  desc "Enable lossless editing of PNGs via a textual representation"
  homepage "https://sng.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sng/sng-1.1.0.tar.gz"
  sha256 "119c55870c1d1bdc65f7de9dbc62929ccb0c301c2fb79f77df63f5d477f34619"
  depends_on "libpng"

  def install
    system "./configure", "--prefix=/usr/local/Cellar/sng/1.1.0"
    system "make", "install"
  end

  test do
    system("curl -o $HOME/test.png 'https://upload.wikimedia.org/wikipedia/en/2/2c/WikiPNGRenderingTestB_Thumb_RGB.png'")
    system("sng $HOME/test.png")
  end
end
