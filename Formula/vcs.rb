class Vcs < Formula
  desc "Creates video contact sheets (previews) of videos"
  homepage "https://p.outlyer.net/vcs/"
  url "https://p.outlyer.net/files/vcs/vcs-1.13.4.tar.gz"
  sha256 "dc1d6145e10eeed61d16c3591cfe3496a6ac392c9c2f7c2393cbdb0cf248544b"

  livecheck do
    url "https://p.outlyer.net/files/vcs/?C=M&O=D"
    regex(/href=.*?vcs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d93ff1a5972e0f9e961bf66ee8bbd99e6037505de83d73f22e69f8683d0ad1b6" => :catalina
    sha256 "d93ff1a5972e0f9e961bf66ee8bbd99e6037505de83d73f22e69f8683d0ad1b6" => :mojave
    sha256 "0873f5c80cc698e7b2ce6d653a43bb51ef363c5e0325997565b30d540e87cb86" => :high_sierra
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
