class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v1.2.tar.gz"
  sha256 "d648a5fb6076c6367e4eac320018ccbd1eddcb2160ce175b361b46fcf0d4a710"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/bavc/qctools.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "3f6dc6987458155d26492c4841d6682e7b616e6191887f87fac898b4dbc9aa67"
    sha256 cellar: :any, arm64_big_sur:  "7b0da0fb3e98787780cb87e3ca2694ff93cec2a5bb40bf4310669128551a0921"
    sha256 cellar: :any, big_sur:        "b1906aa6b03deb8b76f3a7dc89826775fbb53d510885fe99393a54eb941ab3a1"
    sha256 cellar: :any, catalina:       "c600159fad5da4745bd0c04aac536d29d3746ff7398a36b6d276f18c5169d426"
    sha256 cellar: :any, mojave:         "daefc70e69347f50d0392efa2777ca7db0e3c458aa188ab92c0a770b2ef1f8fe"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "qt@5"
  depends_on "qwt-qt5"

  def install
    qt5 = Formula["qt@5"].opt_prefix
    ENV["QCTOOLS_USE_BREW"]="true"

    cd "Project/QtCreator/qctools-lib" do
      system "#{qt5}/bin/qmake", "qctools-lib.pro"
      system "make"
    end
    cd "Project/QtCreator/qctools-cli" do
      system "#{qt5}/bin/qmake", "qctools-cli.pro"
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
