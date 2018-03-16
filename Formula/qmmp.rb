class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "http://qmmp.ylsoftware.com/"
  url "http://qmmp.ylsoftware.com/files/qmmp-1.2.0.tar.bz2"
  sha256 "8020c92e5dd75ed9ab34fd5d1bb524e01f2f361dafd2fe9a3073ae97f5896c9e"
  head "https://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.2/"

  bottle do
    sha256 "fde6046322179080f7d691fead99fba034d1d7e2c215883cb5075800d6b63888" => :high_sierra
    sha256 "af9bfaf97426f5c4610636605c3055827f8812ef0011c477548cbe9db58d8093" => :sierra
    sha256 "1b5c09baa8ea2cb0dfed57048dca8b7c68a70eedcaf683d51d9d273fc653ba46" => :el_capitan
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
