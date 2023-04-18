class Rtmidi < Formula
  desc "API for realtime MIDI input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtmidi/"
  url "https://www.music.mcgill.ca/~gary/rtmidi/release/rtmidi-5.0.0.tar.gz"
  sha256 "48db0ed58c8c0e207b5d7327a0210b5bcaeb50e26387935d02829239b0f3c2b9"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?rtmidi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "d98a3135277ca2176ba1cf2eb0ef854c9528e17d300dabe13e933972d684d002"
    sha256 cellar: :any,                 arm64_monterey: "86041822edcaa7afac16ff5dee154e9a084f52875ed079e7be28855ab975a709"
    sha256 cellar: :any,                 arm64_big_sur:  "bb77151087977965b9ccea0b258d329a92680480e7f4d14d1c18653f124c489e"
    sha256 cellar: :any,                 ventura:        "f204795f8bee6d0b7113705da0b1d5f72cbca35b7b0f8ccebba77a0ac72f22a1"
    sha256 cellar: :any,                 monterey:       "2830c3a78906afda1df6044c480ad2c1812c63ec8350050f67df4d58934d6808"
    sha256 cellar: :any,                 big_sur:        "5b7111fe395363ab657108c3aa974a8fa8aa532f422b0f53b88eb8d8fddf6eb1"
    sha256 cellar: :any,                 catalina:       "43371383eb4e84c1eaac5ac32e71c67ff2d42ec65086a8908929f894a8b18278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d490d8cf367b9f46321551f833fcfa65fcd6d5e9f27ea0b75dd29fdf0b3e4091"
  end

  head do
    url "https://github.com/thestk/rtmidi.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "jack"
  end

  def install
    ENV.cxx11
    system "./autogen.sh", "--no-configure" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
    doc.install %w[doc/release.txt doc/html doc/images] if build.stable?
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "RtMidi.h"
      int main(int argc, char **argv, char **env) {
        RtMidiIn midiin;
        RtMidiOut midiout;
        std::cout << "Input ports: " << midiin.getPortCount() << "\\n"
                  << "Output ports: " << midiout.getPortCount() << "\\n";
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-I#{include}/rtmidi", "-L#{lib}", "-lrtmidi"
    # Only run the test on macOS since ALSA initialization errors on Linux CI.
    # ALSA lib seq_hw.c:466:(snd_seq_hw_open) open /dev/snd/seq failed: No such file or directory
    system "./test" if OS.mac?
  end
end
