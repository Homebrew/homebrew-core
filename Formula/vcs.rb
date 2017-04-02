class Vcs < Formula
  desc "Creates video contact sheets (previews) of videos."
  homepage "https://p.outlyer.net/vcs/"
  url "https://p.outlyer.net/vcs/files/vcs-1.13.2.tar.gz"
  sha256 "fc2a2b3994d5ffb5d87fb3dceaa5f6855aca7a89c58533b12fd11b8fb5b623af"

  bottle do
    cellar :any_skip_relocation
    sha256 "0dca28fe119b535229501593178b46f326e1124880458f56499d0281ce87ccba" => :sierra
    sha256 "dc49a592164ea2e3051b344731baf565819f1e63ec71e0a505bddfd0f06bb61d" => :el_capitan
    sha256 "9722755748810bbb7f75ee2a47161c382fba614845d1407a9825a3b4fb8c0ee6" => :yosemite
    sha256 "d8c55b780119fa7ab6b2bdc7c9b71a8257a612bea52a2a359fdf289fa937509f" => :mavericks
  end

  depends_on "ffmpeg"
  depends_on "gnu-getopt"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "mplayer" => :optional

  def install
    inreplace "vcs", "declare GETOPT=getopt", "declare GETOPT=#{Formula["gnu-getopt"].opt_bin}/getopt"

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{Formula["ffmpeg"].opt_bin}/ffmpeg", "-y", "-filter_complex",
           "testsrc=rate=1:duration=2", "#{testpath}/video.mp4"
    assert (testpath/"video.mp4").exist?

    system "#{bin}/vcs", "#{testpath}/video.mp4", "-n1", "-o", "#{testpath}/video.png"
    assert (testpath/"video.png").exist?
  end
end
