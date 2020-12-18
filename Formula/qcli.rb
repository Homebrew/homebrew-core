class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v1.2.tar.gz"
  sha256 "d648a5fb6076c6367e4eac320018ccbd1eddcb2160ce175b361b46fcf0d4a710"
  license "GPL-3.0"
  head "https://github.com/bavc/qctools.git"

  bottle do
    cellar :any
    sha256 "d489ac1a2fb832390e82994a5b75ecf51b68250a280902d5243bd4c73a48355f" => :big_sur
    sha256 "6091e1d0f155e12219f96bfaa15138c6257b052919cbbf2f4a5fe49a7eb9a7e8" => :catalina
    sha256 "2f1256106214ba171796885b6fc4bf3dd4f39961b1230b83496175524b8e99b5" => :mojave
    sha256 "07a168a9ac1ef80b314696596b6b6cbfa1510f59991e1e11dd3a82027a8403d1" => :high_sierra
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
