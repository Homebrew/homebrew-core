class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "http://qmmp.ylsoftware.com/"
  url "http://qmmp.ylsoftware.com/files/qmmp-1.2.4.tar.bz2"
  sha256 "224904f073e3921a080dca008e6c99e3d606f5442d1df08835cba000a069ae66"
  revision 1
  head "http://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.2/"

  bottle do
    rebuild 1
    sha256 "7f9ab945240bc5f263c4561bdd82b1095992908dca40f4686e7cb6b2ec3c4a48" => :mojave
    sha256 "4d2b7beca1e024c6994e8fe7cfb822b04abff5d7f9b2e200ed7263c34955417d" => :high_sierra
    sha256 "9ffc7e387987e788fb75c1691a3ad7586598b85f79868b616aafbd87df33fb47" => :sierra
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
