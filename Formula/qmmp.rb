class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "http://qmmp.ylsoftware.com"
  url "http://qmmp.ylsoftware.com/files/qmmp-1.1.8.tar.bz2"
  sha256 "17bc88d00ea0753e6fc7273592e894320f05cae807f7cc2c6a5351c73217f010"
  head "http://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.2/"

  bottle do
    sha256 "679fa917fffada98dd35bff2a06476650c122fe8214214d87063507724dedd67" => :sierra
    sha256 "408d3336ef00156ed7ee4af9f0ab95d8ae9dcdd6a5bf8fa082568b033682853b" => :el_capitan
    sha256 "e7252389fc805b90fee400b9b2f3461a9ddc5da69e2e24de002b334e83ece742" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "libogg"
  depends_on "libsoxr"
  depends_on "faad2"
  depends_on "opus"
  depends_on "opusfile"
  depends_on "mplayer"
  depends_on "libbs2b"
  depends_on "libsndfile"
  depends_on "musepack"
  depends_on "taglib"
  depends_on "libmms"
  depends_on "libsamplerate"

  def install
    system "cmake", "./", "-USE_SKINNED", "-USE_ENCA", "-USE_QMMP_DIALOG", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"qmmp", "--version"
  end
end
