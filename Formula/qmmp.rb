class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https://qmmp.ylsoftware.com/"
  url "https://downloads.sourceforge.net/project/qmmp-dev/qmmp/qmmp-1.4.1.tar.bz2"
  sha256 "2ad5e5ce790166a162b942fe64b734559c515ba06c1de5bef46b9713b3c8285c"
  license "GPL-2.0"
  head "https://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.4/"

  livecheck do
    url :stable
    regex(%r{url=.*?/qmmp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "6ccc06e859af7def4f7f3a1ebcdfb845a489b2877cd5ea689cc1f2cb56bf6d9b" => :catalina
    sha256 "95257781b7f40d183b3df114d04bfb3a764c5c88c73d09527c749b56fad8d5cc" => :mojave
    sha256 "00c93a0622ab4bd93553e16fc325563a5df3b0317163c3d939bc507e9dbeab48" => :high_sierra
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
