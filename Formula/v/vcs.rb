class Vcs < Formula
  desc "Creates video contact sheets (previews) of videos"
  homepage "https://p.outlyer.net/vcs/"
  url "https://p.outlyer.net/files/vcs/vcs-1.13.4.tar.gz"
  sha256 "dc1d6145e10eeed61d16c3591cfe3496a6ac392c9c2f7c2393cbdb0cf248544b"
  license "LGPL-2.0-or-later"
  revision 3

  livecheck do
    url "https://p.outlyer.net/files/vcs/?C=M&O=D"
    regex(/href=.*?vcs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "65bbf115d8f6b21bf141e823218b52ce3cae82bfc2c4783d1ffabec160b1c6b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65bbf115d8f6b21bf141e823218b52ce3cae82bfc2c4783d1ffabec160b1c6b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65bbf115d8f6b21bf141e823218b52ce3cae82bfc2c4783d1ffabec160b1c6b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65bbf115d8f6b21bf141e823218b52ce3cae82bfc2c4783d1ffabec160b1c6b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "c910f7b36e0b796a03ebf4fa4a7b2adb315188db72901920abc95c790c3edd8e"
    sha256 cellar: :any_skip_relocation, ventura:        "c910f7b36e0b796a03ebf4fa4a7b2adb315188db72901920abc95c790c3edd8e"
    sha256 cellar: :any_skip_relocation, monterey:       "c910f7b36e0b796a03ebf4fa4a7b2adb315188db72901920abc95c790c3edd8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f48057f0e485f6e6b20d221f4f036e0708d896e6bb3165837e5a96f193710c1b"
  end

  depends_on "ffmpeg"
  depends_on "ghostscript"
  depends_on "imagemagick"

  on_macos do
    depends_on "gnu-getopt"
  end

  def install
    inreplace "vcs", "declare GETOPT=getopt", "declare GETOPT=#{Formula["gnu-getopt"].opt_bin}/getopt" if OS.mac?

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
