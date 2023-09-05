class Rtmidi < Formula
  desc "API for realtime MIDI input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtmidi/"
  url "https://www.music.mcgill.ca/~gary/rtmidi/release/rtmidi-6.0.0.tar.gz"
  sha256 "3336248e8c1f054ea5e51a4449558490dca51edd324fcde0eea27df33b80a9ed"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?rtmidi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8d30eda6f1220b96282f84c8a429e643a439055a775a0d3925fb34e92c6e385d"
    sha256 cellar: :any,                 arm64_monterey: "2a4122c5766cd231a7ed1cf2363d42bd71f3043c52e5630666a981515821483a"
    sha256 cellar: :any,                 arm64_big_sur:  "52ec604c94277d3cd78bd7b4b78a9c6cb0b311b18ee88e8e15047541e7559c22"
    sha256 cellar: :any,                 ventura:        "788be037d24b43b34dd2114fdaeff34937a3b1ac1cec5546823125a02dbd5f48"
    sha256 cellar: :any,                 monterey:       "4db2ae2f3a8f87036914e7ce93f5d735259b70081e017e50311cb147f12aca43"
    sha256 cellar: :any,                 big_sur:        "fd599cea405f192bb57d43ae670db9a0137cef0700b58b5aa665763e716ee6de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a513de7f2e3040c80cf8e6578407758521282e946853860d9a9557508f98dc23"
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
