class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https://qmmp.ylsoftware.com/"
  url "https://downloads.sourceforge.net/project/qmmp-dev/qmmp/qmmp-1.4.6.tar.bz2"
  sha256 "f513774357836ad4983fa216c84cf5db634284faebec48c461733838917fd664"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.4/"

  livecheck do
    url :stable
    regex(%r{url=.*?/qmmp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 big_sur:  "b898d7fd15566fcf1d3eb9fd4fd5f24e02229b694a43cf61b945df95c09a9b67"
    sha256 catalina: "8999d6b60164acb2a85c8c8b575081b28c31bd7dbb1f3ed329b0744775cec0d5"
    sha256 mojave:   "b87e7ce56425fc4c81940506dc79f1357dd0cbeb6fa8bda38254d1d5380a1f14"
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
