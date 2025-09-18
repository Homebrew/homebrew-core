class Rtmidi < Formula
  desc "API for realtime MIDI input/output"
  homepage "https://github.com/thestk/rtmidi"
  url "https://github.com/thestk/rtmidi/archive/refs/tags/6.0.0.tar.gz"
  sha256 "ef7bcda27fee6936b651c29ebe9544c74959d0b1583b716ce80a1c6fea7617f0"
  license "MIT"
  head "https://github.com/thestk/rtmidi.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "8907d310bd719956d2142eafa69ff82047aa7b682b9e6bf46def31cb245a527f"
    sha256 cellar: :any,                 arm64_sequoia: "16b58f421f5acc419193e3e5703910d7984ba6424f2353ad95d7d1d1b4b962aa"
    sha256 cellar: :any,                 arm64_sonoma:  "496714f725960c2a0675ebbdeb419366b882228ce0c0b025b26ebe7b203b6927"
    sha256 cellar: :any,                 sonoma:        "02ee430421083f82fc9614fcfb3143c23d501ec4e85903a16adbab4a1735af9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccdb2162e771404f89f0019084bf7b62abdade723c7ba3b479d4de2db0e5be6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eee4ca1fa59c90126083c01a574ef14c0e5b86f61a473a6bc1109c619f6d14f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "jack"
  end

  def install
    ENV.cxx11
    system "./autogen.sh", "--no-configure"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "RtMidi.h"
      int main(int argc, char **argv, char **env) {
        RtMidiIn midiin;
        RtMidiOut midiout;
        std::cout << "Input ports: " << midiin.getPortCount() << "\\n"
                  << "Output ports: " << midiout.getPortCount() << "\\n";
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-I#{include}/rtmidi", "-L#{lib}", "-lrtmidi"
    # Only run the test on macOS since ALSA initialization errors on Linux CI.
    # ALSA lib seq_hw.c:466:(snd_seq_hw_open) open /dev/snd/seq failed: No such file or directory
    system "./test" if OS.mac?
  end
end
