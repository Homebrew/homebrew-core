class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v0.9.tar.gz"
  sha256 "19ef4be054ebfca70a07043afea20bcca241ba08d70a47acda837ead849aff03"
  revision 1
  head "https://github.com/bavc/qctools.git"

  bottle do
    cellar :any
    sha256 "85c4d9c01c16fb9a23a1e673c5738a153c1c1ecccaf2329d07fe99352cb5ae57" => :high_sierra
    sha256 "4e57855a7745eeefe34ce80e3bfcf01c861b15c51d79c5c58817fc65ff6ebb02" => :sierra
    sha256 "67a2fefb5891000c32e01c3e161762a905afc18e22b36c7cc0e7f4b5b4bb3440" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "qwt"
  depends_on "qt"
  depends_on "ffmpeg"

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
