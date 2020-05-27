class Vcs < Formula
  desc "Creates video contact sheets (previews) of videos"
  homepage "https://p.outlyer.net/vcs/"
  url "https://p.outlyer.net/vcs/files/vcs-1.13.2.tar.gz"
  sha256 "fc2a2b3994d5ffb5d87fb3dceaa5f6855aca7a89c58533b12fd11b8fb5b623af"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "b3531908db412427f55f442a5ddddc79bb23916740a9be8808864ff098283fc7" => :catalina
    sha256 "b3531908db412427f55f442a5ddddc79bb23916740a9be8808864ff098283fc7" => :mojave
    sha256 "25e828b307df1eae19bc5bf09e37e23cd7be0951e4934258c0647e2af4e7a4bb" => :high_sierra
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
