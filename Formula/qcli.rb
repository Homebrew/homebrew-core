class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v0.9.2.tar.gz"
  sha256 "d65ab9da7ff98cc7b939889274514f75c73b8860188a9db1ee5feed69e377eff"
  head "https://github.com/bavc/qctools.git"

  bottle do
    cellar :any
    sha256 "1074efe7d902ab267d65fbf88cd72740764adff0de31ee30a11d23588b0110b5" => :mojave
    sha256 "f7df63180579c72d793a118c574a4a8b3feb83a2e03d911367cc99da31e09782" => :high_sierra
    sha256 "c46b0c071d56de9db2c9cb90da9d799ab4c5c71f2e084de6ea68695019768428" => :sierra
    sha256 "2038f3a2cf2e794cfb62e9a55f2b4a101b488b7183993ed88b83e48287fac936" => :el_capitan
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
