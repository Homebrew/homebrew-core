class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v1.2.1.tar.gz"
  sha256 "17cdc326819d3b332574968ee99714ac982c3a8e19a9c80bcbd3dc6dcb4db2b1"
  license "GPL-3.0-or-later"
  head "https://github.com/bavc/qctools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "715edcf1acb8c6ec82742921b2e69534991174bdd37e4e9ef1a98072acf4cb40"
    sha256 cellar: :any,                 arm64_monterey: "c938fd599d5673faa37050128aee9a772b4839d06904f5590e58418236d12777"
    sha256 cellar: :any,                 arm64_big_sur:  "c21c3d3503c25df679252810f0fe02ce8804d2ca17beca67e4e8d664a40757d0"
    sha256 cellar: :any,                 ventura:        "2429b03da7661875548c9dae60312f71afe1ac85e89019347ae5ea6ae0f73fde"
    sha256 cellar: :any,                 monterey:       "0848ef18376ea60af79db5a6dacd3238057d3026d58301fb2a7005e88835627e"
    sha256 cellar: :any,                 big_sur:        "834aa115e6d3564ecd1b2ee6aa92bb614205c04f219b31ab3afa49394bc4823d"
    sha256 cellar: :any,                 catalina:       "c2bca545b18f596970d770bdcfdd8e8d28fbf8066da7ec1916e6ed8efdd6b45b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec653e796249edd74fa133508baaf3577ed5acbcfead80fa040db92ce741275c"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg@4"
  depends_on "qt@5"
  depends_on "qwt-qt5"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

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
    system "#{Formula["ffmpeg@4"].bin}/ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    # Create a qcli report from the mp4
    qcliout = testpath/"video.mp4.qctools.xml.gz"
    system bin/"qcli", "-i", mp4out, "-o", qcliout
    assert_predicate qcliout, :exist?
  end
end
