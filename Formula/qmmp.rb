class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "http://qmmp.ylsoftware.com/"
  url "http://qmmp.ylsoftware.com/files/qmmp-1.3.5.tar.bz2"
  sha256 "b59b7d4f0f6a0fa9cdf66a07caecb1a4bdc67e8499df331208666e073f66f340"
  head "https://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.3/"

  bottle do
    sha256 "b72c77a5741e5430e164ac75440725d165f02cfe5feecec935efa94db2496d16" => :catalina
    sha256 "511f525b513663c2c8fe713c297425815b6c5ac4623049944ba93aea4effd13e" => :mojave
    sha256 "e0847a2e67ca2156b2c10a53c7ab0f289365f332578e286ddef25e58d7a89cf3" => :high_sierra
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
