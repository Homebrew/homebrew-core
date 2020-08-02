class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v1.1.tar.gz"
  sha256 "e11eb93b02f9c75f88182a57b8ab44248ac10ca931cf066e7f02bd1835f2900c"
  license "GPL-3.0"
  revision 2
  head "https://github.com/bavc/qctools.git"

  bottle do
    cellar :any
    sha256 "a64e0d73cd4a2d8381133b862d8781a63c17380da45ad50fb994560b04430b53" => :catalina
    sha256 "3a1bf39203f4167a06479c3d03647e275530e87f2ab73bd9edbf539ff119f0dd" => :mojave
    sha256 "5e69cecec0a4762ce9f17b4fc6c40fcb3d8e22a0e9856309e5b981c98c505fa6" => :high_sierra
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
