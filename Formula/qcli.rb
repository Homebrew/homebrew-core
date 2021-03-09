class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v1.2.tar.gz"
  sha256 "d648a5fb6076c6367e4eac320018ccbd1eddcb2160ce175b361b46fcf0d4a710"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/bavc/qctools.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "cef087971d3749ecf47034171457c2cc838dad1298f5f7606a524b4c86f9d2f3"
    sha256 cellar: :any, big_sur:       "227a1bf258d07d729f5060e75c512b708bf6fa816e40adc9d4126dafd3fabbdf"
    sha256 cellar: :any, catalina:      "b4822c9f864d0fe3b0a0d1e81efaef5daaad3e3f7efd3d520a0ebb711181622d"
    sha256 cellar: :any, mojave:        "39f76c5605152c55bc40454dfbf2ec895af7d2a359c88692bbe0c49388c0a478"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "qt@5"
  depends_on "qwt"

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
