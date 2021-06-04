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
    sha256 big_sur:  "9dee25c49a89bedc44b8a45cce9c1eee237f0d04b2765a930e2482baed663f3c"
    sha256 catalina: "3a59c33536865917e8426e7076d6e33aa465add0f0d89a60edb1dded6ef475ab"
    sha256 mojave:   "7ff2b3f1d2b6adb30d9a8051e1c19e822eaac3643483d16150a15116d0179879"
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
