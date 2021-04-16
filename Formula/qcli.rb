class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v1.2.tar.gz"
  sha256 "d648a5fb6076c6367e4eac320018ccbd1eddcb2160ce175b361b46fcf0d4a710"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/bavc/qctools.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0d9f37d9080941a3cc46915af7b014e86ab38f863efd986dcec8b3fc4c4adf30"
    sha256 cellar: :any, big_sur:       "e0ccef859a1e5c18e2c8ce01ce6bb1b58a83489ef20670909a5c4b07c284c4b6"
    sha256 cellar: :any, catalina:      "6615b8e8fef95ec1ac8b2b60857071b172278281a2a404c3553e9f1571d03d8a"
    sha256 cellar: :any, mojave:        "c918566c4dd012489eac5453d022a2ad0ab97c61d803c358f722234b7ea72d90"
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
