class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https://qmmp.ylsoftware.com/"
  url "https://downloads.sourceforge.net/project/qmmp-dev/qmmp/qmmp-1.4.0.tar.bz2"
  sha256 "a8b9cda1fe137f9b50acc54bc02ac1f3ba89051f828f40f5dc9a9056cab4308f"
  license "GPL-2.0"
  head "https://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.4/"

  bottle do
    sha256 "6269f254fbe8cadba8f6e23a7291651978a03628fadb8146aaf660879a748150" => :catalina
    sha256 "10ad28d16385025291bf0047719ab2fa223839891aae80abd09e4fceb4c2b616" => :mojave
    sha256 "7e7bce18642ee3d3bdf242d4dd83337e8a55723d39bfe870f84e6a67e6911247" => :high_sierra
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
