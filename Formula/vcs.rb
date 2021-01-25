class Vcs < Formula
  desc "Creates video contact sheets (previews) of videos"
  homepage "https://p.outlyer.net/vcs/"
  url "https://p.outlyer.net/files/vcs/vcs-1.13.4.tar.gz"
  sha256 "dc1d6145e10eeed61d16c3591cfe3496a6ac392c9c2f7c2393cbdb0cf248544b"
  revision 3

  livecheck do
    url "https://p.outlyer.net/files/vcs/?C=M&O=D"
    regex(/href=.*?vcs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f13c9ce9291572d343bb3411e059601aa71fc4776138f13d33941653aab4dfb4" => :big_sur
    sha256 "5a12b2c51afec7626a44463cd9145bf47819e8561f05194f2f17ea8eec0459c9" => :arm64_big_sur
    sha256 "3ae09912577433e9aee40da787b21b278d2e4d625454e6a554a10dfd71a3cb82" => :catalina
    sha256 "2100a37453706602e0bd5941c7fb343cf64659493b27889957bad498934c6daf" => :mojave
  end

  depends_on "ffmpeg"
  depends_on "ghostscript"
  depends_on "gnu-getopt"
  depends_on "imagemagick"

  def install
    inreplace "vcs", "declare GETOPT=getopt", "declare GETOPT=#{Formula["gnu-getopt"].opt_bin}/getopt"

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system Formula["ffmpeg"].bin/"ffmpeg", "-f", "rawvideo", "-s", "hd720",
           "-pix_fmt", "yuv420p", "-r", "30", "-t", "5", "-i", "/dev/zero",
           testpath/"video.mp4"
    assert_predicate testpath/"video.mp4", :exist?

    system bin/"vcs", "-i", "1", "-o", testpath/"sheet.png", testpath/"video.mp4"
    assert_predicate testpath/"sheet.png", :exist?
  end
end
