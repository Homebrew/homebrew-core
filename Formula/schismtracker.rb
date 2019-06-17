class Schismtracker < Formula
  desc "Portable reimplementation of Impulse Tracker"
  homepage "http://schismtracker.org/"
  url "https://github.com/schismtracker/schismtracker/archive/20190614.tar.gz"
  sha256 "08a8b60bd31973b9e1c1ba823b5bc8e9b5291f6677401b944e8b80d8a565cd8e"
  head "https://github.com/schismtracker/schismtracker.git"

  bottle do
    cellar :any
    sha256 "411fee4b921f6c447dd5a7202188b57d72ed87ae54787affd28bccf3f525f7c4" => :mojave
    sha256 "57cbd8ab22799f39305a611dbc40f79eb9c089327e8146d0b81edb1e0e3249d5" => :high_sierra
    sha256 "3af0c48a5d0a9124e1c7e6b4b064fbdf090b57c646064b4231c2f65e232a37fa" => :sierra
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
