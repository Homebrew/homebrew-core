class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v1.1.tar.gz"
  sha256 "e11eb93b02f9c75f88182a57b8ab44248ac10ca931cf066e7f02bd1835f2900c"
  license "GPL-3.0"
  revision 3
  head "https://github.com/bavc/qctools.git"

  bottle do
    cellar :any
    sha256 "ef657d1dc674393cd3ab389527392dce56ddb392c0d89b818680bcbab67a1715" => :catalina
    sha256 "d36d29273a40bdbdb7007392ab487fc5175cbba239611bb188d46927c8cd67bf" => :mojave
    sha256 "89caf6ebb740e3f1ffa15401afb6f1529b32bf152153f3934d462fb888e4a7e3" => :high_sierra
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
