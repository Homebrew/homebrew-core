class Schismtracker < Formula
  desc "Portable reimplementation of Impulse Tracker"
  homepage "http://schismtracker.org/"
  url "https://github.com/schismtracker/schismtracker/archive/20160913.tar.gz"
  sha256 "3c2fcea458ba7b41bcc63ee786c7eef0bfe8775639a3db8fab863e12f10888e9"
  head "https://bitbucket.org/Storlek/schismtracker", :using => :hg

  bottle do
    cellar :any
    sha256 "e0fa2e3eb25b038e067be617c536e09bbdf9188d98b0254a638861b0bde71a44" => :sierra
    sha256 "bb5175efc06e4934ff00de80dffee0e8d65c72dbb2246ea1a6ec0b7b4c316c93" => :el_capitan
    sha256 "f4a9b508b8547098848c4f1343c55c814093d05afe73a4141f74478f7bada4eb" => :yosemite
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
    test_wav = "#{testpath}/test.wav"
    system "#{bin}/schismtracker", "-p", "#{testpath}/give-me-an-om.mod",
           "--diskwrite=#{test_wav}"
    assert File.exist? test_wav
    assert_match /RIFF \(little-endian\) data, WAVE audio, Microsoft PCM, 16 bit, stereo 44100 Hz/,
                 shell_output("/usr/bin/file '#{test_wav}'")
  end
end
