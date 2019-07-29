class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v1.0.tar.gz"
  sha256 "4b687eb9aedf29a8262393079669d3870c04b510669b9df406021243b8ebd918"
  head "https://github.com/bavc/qctools.git"

  bottle do
    cellar :any
    sha256 "ff59d63feaa9096773228c1e4dd866da2e5bd5812c38645669c80c31be3c7bc8" => :mojave
    sha256 "d726ff0f06c9e604a95d36d0eae58ca886c6b2024cefe4d77adc92598dd8d56d" => :high_sierra
    sha256 "837745fe83f29aa3d83de03bd7ed22785248eb9328a5f18bda8a04e151af3c62" => :sierra
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
