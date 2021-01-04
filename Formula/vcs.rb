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
    sha256 "2c969fddac4c38cdc33a0d34677b13cd63d78d2b16ba972830b875f34bbc5645" => :big_sur
    sha256 "c0b9e4f330429c4b11eac00d2be7109789384c727cbeaa4825309008f2aa49be" => :arm64_big_sur
    sha256 "bc404841c013cf935691020cc3bac998161d800a2a98f72fb1e5821e6c07ea28" => :catalina
    sha256 "df66eb7ddab36140a72c6be470d5629cb4ed31f74c168cc70ddb622877b47920" => :mojave
    sha256 "adefb8791367c30169a8fae3aee792521d4082adb33e7dfd7626db88901e84ed" => :high_sierra
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
