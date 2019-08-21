class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "http://qmmp.ylsoftware.com/"
  url "http://qmmp.ylsoftware.com/files/qmmp-1.3.3.tar.bz2"
  sha256 "471c93cdd15f635893c00db72865e5d475eaf85b0f00cf15c550cfb51f9ee79c"
  head "https://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.3/"

  bottle do
    sha256 "d1353a062520dc70411c0bfff5f36c9f76ed48ebb50f9e7add744504fe3bd697" => :mojave
    sha256 "e10cdedfcb52eb2e9aef4a6b567b26074bb158d198ca316c01cb24be6ace1666" => :high_sierra
    sha256 "daf215ab47999253201918524c85ab08c288291e55ed725e0ebfd35c47401d64" => :sierra
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

    # fix linkage
    cd (lib.to_s) do
      Dir["*.dylib", "qmmp/*/*.so"].select { |f| File.ftype(f) == "file" }.each do |f|
        MachO::Tools.dylibs(f).select { |d| d.start_with?("/tmp") }.each do |d|
          bname = File.dirname(d)
          d_new = d.sub(bname, opt_lib.to_s)
          MachO::Tools.change_install_name(f, d, d_new)
        end
      end
    end
  end

  test do
    system bin/"qmmp", "--version"
  end
end
