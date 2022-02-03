class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v1.2.tar.gz"
  sha256 "d648a5fb6076c6367e4eac320018ccbd1eddcb2160ce175b361b46fcf0d4a710"
  license "GPL-3.0-or-later"
  revision 5
  head "https://github.com/bavc/qctools.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "0e2707f85fe62042c441ec6f28a67dccda0fc7f552ad41e9363b3c5634a809d3"
    sha256 cellar: :any, arm64_big_sur:  "37801ced68f76e6f985ba30b53bc9c2d3fbb626aba5c55a54c43510f0f6ec88f"
    sha256 cellar: :any, big_sur:        "f4a8176d41ed4d7953588917d500c7eb80418e560d4da82bb4e454b05fbb063b"
    sha256 cellar: :any, catalina:       "4a49db35814ab46eeb163b3fcd079dfa10e7e0dcc6ca3ad8f7ac8e0e863cc3c8"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg@4"
  depends_on "qt@5"
  depends_on "qwt-qt5"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

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
