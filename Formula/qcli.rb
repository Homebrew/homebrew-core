class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v0.9.2.tar.gz"
  sha256 "d65ab9da7ff98cc7b939889274514f75c73b8860188a9db1ee5feed69e377eff"
  head "https://github.com/bavc/qctools.git"

  bottle do
    cellar :any
    sha256 "1bae0695d9e4e0dd947b78481f25011efb0b832a063ad158f101e8ce855214d7" => :high_sierra
    sha256 "b817acbcfae33eca85e88208a64561d6eacbda6a6faaf77b571a87d31e721102" => :sierra
    sha256 "6464309db798ca82199a26bb43bdddeced1bb279b4a05b6b7602d9852191c2e6" => :el_capitan
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
