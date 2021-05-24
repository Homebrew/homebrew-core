class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https://qmmp.ylsoftware.com/"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/qmmp-dev/code/branches/qmmp-1.5/"

  stable do
    url "https://downloads.sourceforge.net/project/qmmp-dev/qmmp/qmmp-1.5.0.tar.bz2"
    sha256 "2f796bdbfeee4c1226541e746bcfea3d5b983a559081529e4c86a2c792026be7"

    # Fix build without mpg123
    # See https://sourceforge.net/p/qmmp-dev/tickets/1082/
    # Remove in the next release
    patch :DATA
  end

  livecheck do
    url :stable
    regex(%r{url=.*?/qmmp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 big_sur:  "314ceb6432da04c39b83c600d22bafee2a680b6c34ef47c238e160181583e7bb"
    sha256 catalina: "53def71f6922fb2f7f7cfd3557d321011f82015d8d7a259c5aac0f17d0da986b"
    sha256 mojave:   "2471e481be569677e931cb5588e53d9359bb3ff8b403b8a0051d8c77ff4e7702"
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

__END__
--- a/src/plugins/Input/mpeg/decodermpegfactory.cpp
+++ b/src/plugins/Input/mpeg/decodermpegfactory.cpp
@@ -204,7 +204,9 @@
         d = new DecoderMAD(crc, input);
     }
 #elif defined(WITH_MAD)
-    d = new DecoderMAD(input);
+    QSettings settings(Qmmp::configFile(), QSettings::IniFormat);
+    bool crc = settings.value("MPEG/enable_crc", false).toBool();
+    d = new DecoderMAD(crc, input);
 #elif defined(WITH_MPG123)
     d = new DecoderMPG123(input);
 #endif
