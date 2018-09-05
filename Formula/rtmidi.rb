class Rtmidi < Formula
  desc "C++ classes that provide a common API for realtime MIDI input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtmidi/"
  url "https://github.com/thestk/rtmidi/archive/v3.0.0.tar.gz"
  sha256 "55cd0fba60321aadcd847481d207bf2b70e783b5bfa1a01037bf916554a7d5c4"

  bottle do
    cellar :any
    sha256 "8a2a9782decb8dc5cf871ed408ab3d924438df2feab9506ca53cba1d74bb1cb8" => :mojave
    sha256 "f4a74942bb3c18351c0ff2d77a27703d70aa3311f3a39228a7615c424e9fac79" => :high_sierra
    sha256 "27e811c4d1ad96adbc31f2f432543b85907a065a91cc0a4e515e980a2f45b253" => :sierra
    sha256 "387b587f77423ee2ecfd716fa5235aa235ba5d33632b2765292ec318e0d67af3" => :el_capitan
    sha256 "6e2f97819b113f8c95618377030170ddba66e79085f4f1553306b77e99683c6c" => :yosemite
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
