class Schismtracker < Formula
  desc "Portable reimplementation of Impulse Tracker"
  homepage "http://schismtracker.org/"
  url "https://github.com/schismtracker/schismtracker/archive/20190805.tar.gz"
  sha256 "855205db8047e4d76faf46b80c2b7209f1f8f26be44973334fa7b74684c08cc1"
  head "https://github.com/schismtracker/schismtracker.git"

  bottle do
    cellar :any
    sha256 "e19f4377d0fe9b94cc3fb3dca302b568cf4a859d143169172daf4f0c27860bdf" => :mojave
    sha256 "52c5bfd7fcd8fff45d5c8091486bdeae738e995393c3f15af33f25e49faafabe" => :high_sierra
    sha256 "9c922df0a4ac31e7bcd1a2782262d1e10c84811e644c180a6402de031c89964b" => :sierra
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
