class Rtmidi < Formula
  desc "C++ classes that provide a common API for realtime MIDI input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtmidi/"
  url "https://www.music.mcgill.ca/~gary/rtmidi/release/rtmidi-4.0.0.tar.gz"
  sha256 "370cfe710f43fbeba8d2b8c8bc310f314338c519c2cf2865e2d2737b251526cd"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?rtmidi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3abdd10f5c4af06e7c403f4a45a92059d0210787d95b5c2cdcfe7cad0fba0bfd"
    sha256 cellar: :any,                 arm64_big_sur:  "494faf5859eded9a849b50f8ce6ea813b7de240e0a555c5b62817e9225cc5c4e"
    sha256 cellar: :any,                 monterey:       "de0d5ea56b7f220bc83b6927621462df8d93013e68a1540e2d32983a8dabde4d"
    sha256 cellar: :any,                 big_sur:        "1a11b007b42c9e270354f47a2c97d42f20a4cea8f7a6b8976efd9535e6cfa077"
    sha256 cellar: :any,                 catalina:       "f65ae764cc0d13549206e5c4d5a47285b412876e97a89a7ea7ec404e8565800a"
    sha256 cellar: :any,                 mojave:         "9f8dfe0f1928c824e73d5e6d8f246db3abc8a2463fde613b7ac14fd3a6fc4602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e952cc781a61c347d77ed1c91c941b47c87152fd2b91a653edd77787c57dd467"
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
    system "./autogen.sh", "--no-configure" if build.head?
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
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
    system ENV.cxx, "test.cpp", "-I#{include}/rtmidi", "-L#{lib}", "-lrtmidi", "-o", "test"
    # Only run the test on macOS since ALSA initialization errors on Linux CI.
    # ALSA lib seq_hw.c:466:(snd_seq_hw_open) open /dev/snd/seq failed: No such file or directory
    system "./test" if OS.mac?
  end
end
