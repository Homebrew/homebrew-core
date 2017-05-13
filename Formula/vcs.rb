class Vcs < Formula
  desc "Creates video contact sheets (previews) of videos."
  homepage "https://p.outlyer.net/vcs/"
  url "https://p.outlyer.net/vcs/files/vcs-1.13.2.tar.gz"
  sha256 "fc2a2b3994d5ffb5d87fb3dceaa5f6855aca7a89c58533b12fd11b8fb5b623af"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d9b65057f5f6746e32f075af250611956e3fecf6aae5300ce517fe0edfb155cc" => :sierra
    sha256 "93bf052fe5378df11b4dfa929d6c2aea6a5a623a198a8a765374332ca662dfaf" => :el_capitan
    sha256 "93bf052fe5378df11b4dfa929d6c2aea6a5a623a198a8a765374332ca662dfaf" => :yosemite
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
