class Schismtracker < Formula
  desc "Portable reimplementation of Impulse Tracker"
  homepage "http://schismtracker.org/"
  url "https://github.com/schismtracker/schismtracker/archive/20181223.tar.gz"
  sha256 "fc32930c611fdb78face87dbe8a3c62e70088fd8d4ad803140e0b9a0b2e72ad7"
  head "https://github.com/schismtracker/schismtracker.git"

  bottle do
    cellar :any
    sha256 "33e177bd2dcf065a78fec1e6c209f8c3bb1abf5cd71ee1e04c68358f0f6bf9f4" => :mojave
    sha256 "e23c65a61cff81729816d167bf68bc2ff73febf01fc8ad66b493f8801515b399" => :high_sierra
    sha256 "d9381cb1a53c0f5d822d77308cdca06000c48e8501130ea3cdc58cf0b94ae1d1" => :sierra
    sha256 "5f31b90bcd0d75eb16ac32b5f588ea838c852a088fc8978fec36402a8705c223" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "sdl"

  # CC BY-NC-ND licensed set of five mods by Keith Baylis/Vim! for testing purposes
  # Mods from Mod Soul Brother: https://web.archive.org/web/20120215215707/www.mono211.com/modsoulbrother/vim.html
  resource "demo_mods" do
    url "https://files.scene.org/get:us-http/mirrors/modsoulbrother/vim/vim-best-of.zip"
    sha256 "df8fca29ba116b10485ad4908cea518e0f688850b2117b75355ed1f1db31f580"
  end

  def install
    system "autoreconf", "-ivf"

    mkdir "build" do
      # Makefile fails to create this directory before dropping files in it
      mkdir "auto"

      system "../configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    testpath.install resource("demo_mods")
    test_wav = testpath/"test.wav"
    system "#{bin}/schismtracker", "-p", "#{testpath}/give-me-an-om.mod",
           "--diskwrite=#{test_wav}"
    assert_predicate test_wav, :exist?
    assert_match /RIFF \(little-endian\) data, WAVE audio, Microsoft PCM, 16 bit, stereo 44100 Hz/,
                 shell_output("/usr/bin/file '#{test_wav}'")
  end
end
