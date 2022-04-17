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
    sha256 cellar: :any,                 arm64_monterey: "119f3146edf9cc4cea730af3f7cc5ed437116e5b9883eee93d1b1c3b5ec272fa"
    sha256 cellar: :any,                 arm64_big_sur:  "d435e2c62031b6875cb20f74afd51dfa6a139d939fa8b086178c0ae8951c8b29"
    sha256 cellar: :any,                 monterey:       "bcfcec8795e6500eba8b58b940d52df7bcf23238807167e314ff88433493aa04"
    sha256 cellar: :any,                 big_sur:        "1fda9d73d29790438c32a1cb18b9ef58d1634e6e66342e5fce0b1a12f2e85556"
    sha256 cellar: :any,                 catalina:       "f6cec4256b87acc86cde5f876fac9181972ffa36c60278abbd2e0c4b0f05d10d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04b6086029ec9145007d5f7d4ea3fef4fba38d5389bab5d1d1a7c5860d864271"
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
