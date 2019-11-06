class Rtmidi < Formula
  desc "C++ classes that provide a common API for realtime MIDI input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtmidi/"
  url "https://www.music.mcgill.ca/~gary/rtmidi/release/rtmidi-4.0.0.tar.gz"
  sha256 "370cfe710f43fbeba8d2b8c8bc310f314338c519c2cf2865e2d2737b251526cd"

  bottle do
    cellar :any
    sha256 "527496c834c7c98aca105255a39cf80ddaa074c7073e24d3325eb66ab4b07754" => :catalina
    sha256 "5cb51ca3774a1e22d2388f01ccb514d091519b9d8cbc5f4805437be1be7dba30" => :mojave
    sha256 "8744fb2c8d9952b0e14e50f2fed7982e715843746506378645211a178a3163e0" => :high_sierra
    sha256 "4eab0eb4ede3d1035d7918bd84e2aede8f648c2ebcf449ac6f9ce15c0c744988" => :sierra
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
    (testpath/"test.cpp").write <<~EOS
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
