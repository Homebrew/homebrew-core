class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v1.2.tar.gz"
  sha256 "d648a5fb6076c6367e4eac320018ccbd1eddcb2160ce175b361b46fcf0d4a710"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/bavc/qctools.git"

  bottle do
    cellar :any
    sha256 "8a4928c33d4be801e30927b50b2badf54a88c38a9e1c57715c0b4c87a893c739" => :big_sur
    sha256 "a25bcb4a21a2a5eaa3fd3789fc2065312bbe09ce080810fc663d1cd133bb81e2" => :catalina
    sha256 "c543c4a06c3c4c72c3d003047ece7850ac63d9e6e2e044fa09b48f20b9abfd5e" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "qt"
  depends_on "qwt"

  def install
    ENV["QCTOOLS_USE_BREW"]="true"

    cd "Project/QtCreator/qctools-lib" do
      system "qmake", "qctools-lib.pro"
      system "make"
    end
    cd "Project/QtCreator/qctools-cli" do
      system "qmake", "qctools-cli.pro"
      system "make"
      bin.install "qcli"
    end
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system "ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    # Create a qcli report from the mp4
    qcliout = testpath/"video.mp4.qctools.xml.gz"
    system bin/"qcli", "-i", mp4out, "-o", qcliout
    assert_predicate qcliout, :exist?
  end
end
