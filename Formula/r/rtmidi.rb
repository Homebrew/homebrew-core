class Rtmidi < Formula
  desc "API for realtime MIDI input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtmidi/"
  url "https://www.music.mcgill.ca/~gary/rtmidi/release/rtmidi-6.0.0.tar.gz"
  sha256 "5960ccf64b42c23400720ccc880e2f205677ce9457f747ef758b598acd64db5b"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?rtmidi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "1c3e7eb76b81cc7b731bb82550bf888bec6add154b060f975b8f4ef0c907e4cd"
    sha256 cellar: :any,                 arm64_sonoma:   "739b40a37e29e6ec2b6f3f4a53cab1e489f7a9dd4698102604b227ea5c140b0b"
    sha256 cellar: :any,                 arm64_ventura:  "c18948de83007b0ca3e87cb01f9161c92038f8ad080c075a2a9746bcff14f78a"
    sha256 cellar: :any,                 arm64_monterey: "00a10d87416a8ce037c98b15bc67a4a5c8780f065f8d0f73c470c0eaf3dd5d9a"
    sha256 cellar: :any,                 sonoma:         "af76d8dc24430b39e31a093c525d398801eb8908a0c08fc7145bd767879d9422"
    sha256 cellar: :any,                 ventura:        "65861bc757b6d02b30addc5fc15751927b3e82e33d03164bb02019976c1a20d5"
    sha256 cellar: :any,                 monterey:       "e106cd4273619be027dd5b8c1bc445d0b316753e9d541c7afe07a1dbd84fcdcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0f090a86a72631f9c0a800dd524f2914b313b7610a82ce34148e0d62a3af266b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fff0e784b8a8779f1b8096e51b4d812d0190f7248c1fdf9ec75c5fe13c11b29"
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
