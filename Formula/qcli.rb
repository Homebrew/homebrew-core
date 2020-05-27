class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v1.1.tar.gz"
  sha256 "e11eb93b02f9c75f88182a57b8ab44248ac10ca931cf066e7f02bd1835f2900c"
  revision 1
  head "https://github.com/bavc/qctools.git"

  bottle do
    cellar :any
    sha256 "7c92e518aba3e06cd3442b2c2c7cf426660d5cfdb73e1cb3e3b81ff8064eda43" => :catalina
    sha256 "25f7fb43d401ba9ebf7043629dc2e66c12489fe06886723e535548e20d651152" => :mojave
    sha256 "6e3b5d65bb6511acbe090146ca25695d33799032d4e20a3458652f81757d7ecc" => :high_sierra
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
