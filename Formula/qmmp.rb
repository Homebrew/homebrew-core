class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "http://qmmp.ylsoftware.com/"
  url "http://qmmp.ylsoftware.com/files/qmmp-1.2.2.tar.bz2"
  sha256 "e9dc5723f7f2a04d36167585ce1b4223c09f36c6dad1215de877dc51d1f3d606"
  head "https://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.2/"

  bottle do
    sha256 "221e26205bbbccf57d16f8317213c2ba9c120bd7766f07d68127f834e54fc3e1" => :high_sierra
    sha256 "c834f256c2efbd8353e56dd27321b0e34087fd3e275e429ed135507d8c21aea1" => :sierra
    sha256 "8be08514cb41775e7ede35d644b526f5066e3ad7d763dc954accb025379a2b1d" => :el_capitan
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
