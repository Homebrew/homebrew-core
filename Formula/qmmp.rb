class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "http://qmmp.ylsoftware.com/"
  url "http://qmmp.ylsoftware.com/files/qmmp-1.3.3.tar.bz2"
  sha256 "471c93cdd15f635893c00db72865e5d475eaf85b0f00cf15c550cfb51f9ee79c"
  head "https://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.3/"

  bottle do
    sha256 "7c1b47197fe2ac57e24412a1b98ab6566d45ef84693c48ba5b9c5da3d6b4a501" => :mojave
    sha256 "5e24216b88f75d6542d6be523ee9ebbad1fd6cda199b3790c2e2db81fb0e89cc" => :high_sierra
    sha256 "119ac7be32b53b1bc2b40ebf291d0a044d7a8e0fddc7ed109d0a4aee28c399ad" => :sierra
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
