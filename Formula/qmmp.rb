class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https://qmmp.ylsoftware.com/"
  url "https://downloads.sourceforge.net/project/qmmp-dev/qmmp/qmmp-1.4.3.tar.bz2"
  sha256 "293dbe5e64bc7c1a6f40a7b34dadc84d4689cb1339a49aa79c3ebe1963318b48"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.4/"

  livecheck do
    url :stable
    regex(%r{url=.*?/qmmp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "b75b2d8400ba9a4bf4d17bc3c7acbbca2c8ecc1dfe89271cb49649527cd41822" => :big_sur
    sha256 "dc373e70a5e39c03100a8d66a6995411c9d2b2b6204ef511696709723eede9fa" => :catalina
    sha256 "40ed59d91debfce6abe01685d4cc31a7ebd11081a118866971135ae7d9ea794d" => :mojave
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
