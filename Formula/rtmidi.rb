class Rtmidi < Formula
  desc "C++ classes that provide a common API for realtime MIDI input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtmidi/"
  url "https://github.com/thestk/rtmidi/archive/v3.0.0.tar.gz"
  sha256 "55cd0fba60321aadcd847481d207bf2b70e783b5bfa1a01037bf916554a7d5c4"

  bottle do
    cellar :any
    sha256 "700e8a7768437ed27b87b9ee0642553a01d572556c21b8551bc62576d9e21f5e" => :sierra
    sha256 "cd2de94d4142db7007d85e48ee11568101d7addd164a80340c6d198744059feb" => :el_capitan
    sha256 "2c13437c6b86ed8332cea90bb0d666f15706daf728fabc0200878bd3f1870874" => :yosemite
    sha256 "0718f6114ed75db09006bf375abf1c14e1142e716030de05d9843f63a70c3759" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh", "--no-configure"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    lib.install Dir[".libs/*.a", ".libs/*.dylib"]
    include.install Dir["*.h"]
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include "RtMidi.h"
      int main(int argc, char **argv, char **env) {
        RtMidiIn midiin;
        RtMidiOut midiout;
        std::cout << "Input ports: " << midiin.getPortCount() << "\\n"
                  << "Output ports: " << midiout.getPortCount() << "\\n";
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lrtmidi", "-o", "test"
    system "./test"
  end
end
