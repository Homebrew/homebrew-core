class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https://qmmp.ylsoftware.com/"
  url "https://downloads.sourceforge.net/project/qmmp-dev/qmmp/1.5/qmmp-1.5.1.tar.bz2"
  sha256 "f3dc676039b5f190e6a87377a6b2bd2bcca122d1659b5f22668c7a284bb91f43"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.5/"

  livecheck do
    url :stable
    regex(%r{url=.*?/qmmp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 big_sur:  "144bd80fb2a050a68900c40a44f00fc05fb7addc660e7807e900a129f86b8a89"
    sha256 catalina: "feff3c70d129d608e05e83928031134d9422cfedb52f305617a2c3af62802f19"
    sha256 mojave:   "7001d36b42beb62f494c03d0e15bf5a153712ad9784af50df1e8042b52d682f6"
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
  depends_on "qt@5"
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
