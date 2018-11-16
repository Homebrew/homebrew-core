class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "http://qmmp.ylsoftware.com/"
  url "http://qmmp.ylsoftware.com/files/qmmp-1.2.4.tar.bz2"
  sha256 "224904f073e3921a080dca008e6c99e3d606f5442d1df08835cba000a069ae66"
  revision 1
  head "http://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.2/"

  bottle do
    sha256 "e8f99667d65835bdca131b967a1f49329431bc1665b92195349ece4938f8fdd4" => :mojave
    sha256 "4ae653f15662ef557431588ec2a2174ec09185a9d6351a99c66690e7df6b6b29" => :high_sierra
    sha256 "5e51e8e463d0dd9f4074d08ffb46f62862771d790cc4d5cab00fbdf276f3cb4e" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libbs2b"
  depends_on "libmms"
  depends_on "libogg"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "mplayer"
  depends_on "musepack"
  depends_on "opus"
  depends_on "opusfile"
  depends_on "qt"
  depends_on "taglib"

  def install
    system "cmake", "./", "-USE_SKINNED", "-USE_ENCA", "-USE_QMMP_DIALOG", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"qmmp", "--version"
  end
end
