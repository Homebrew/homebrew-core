class Rtmidi < Formula
  desc "API for realtime MIDI input/output"
  homepage "https://github.com/thestk/rtmidi"
  url "https://github.com/thestk/rtmidi/archive/refs/tags/6.0.0.tar.gz"
  sha256 "ef7bcda27fee6936b651c29ebe9544c74959d0b1583b716ce80a1c6fea7617f0"
  license "MIT"
  revision 1
  head "https://github.com/thestk/rtmidi.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ceed684241bc1687094e6052effca2bd7790d7dcf6e50b34ad65dbcbcdd92bda"
    sha256 cellar: :any, arm64_sequoia: "4d1335014ddd04394a77ea4a9b708c7d9ac5fc6b1f1f0f5007f24e2520c5badd"
    sha256 cellar: :any, arm64_sonoma:  "8ec6008f1f9002017e8f763b500ec1bcbba1261d4412a87c0394bf95c4105709"
    sha256 cellar: :any, sonoma:        "0b4c9af10733921f5552f95b6fa52125677c4260462f324c523d6aac8f541137"
    sha256 cellar: :any, arm64_linux:   "88f2b667e7c648e4bdda70ab47b3714c8ecd7bb4a6b4bacfd1758df17dc82db2"
    sha256 cellar: :any, x86_64_linux:  "efcba96923a670026dd2655f9dc211ece664cc973bc0cfdb50d3360ff5885b82"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "jack"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DRTMIDI_BUILD_TESTING=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
