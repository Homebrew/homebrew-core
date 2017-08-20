class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v0.9.tar.gz"
  sha256 "19ef4be054ebfca70a07043afea20bcca241ba08d70a47acda837ead849aff03"
  head "https://github.com/bavc/qctools.git"

  bottle do
    cellar :any
    sha256 "6200911ae64e941a8a7dcc8ea37477a96acfb7814a5386c9dea3e8f97dc0c53b" => :sierra
    sha256 "b5b4eae345ae1a8a51bd61d042b91ccfb5c3d692990744e714385ff9421506a3" => :el_capitan
    sha256 "5c793f95aaefa2e388bbab254ee25abfc62d9c168826afa3391ad0214ce12df1" => :yosemite
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
    assert qcliout.exist?
  end
end
