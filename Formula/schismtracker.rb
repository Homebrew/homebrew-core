class Schismtracker < Formula
  desc "Portable reimplementation of Impulse Tracker"
  homepage "http://schismtracker.org/"
  url "https://bitbucket.org/Storlek/schismtracker/get/20120105.tar.bz2"
  sha256 "736163682c476c2f1afca9b3ebf2a1f5d1a0420dc2da12f2d8cfe6d1b3de379b"
  head "https://bitbucket.org/Storlek/schismtracker", :using => :hg

  bottle do
    cellar :any
    sha256 "98dc9ae978d7fb1edcfe16565099c1bd1aca7da559d39a11e29efc1df94a8bac" => :el_capitan
    sha256 "1eee656439ae0fc622c441ddb850ead5c5d361326b556e16f9ce00437988a86a" => :yosemite
    sha256 "f892d60e3e74f352d7d9efbbf84b6470e4e751ffafe55c9b6ab9913bd611dba2" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "sdl"

  # CC BY-NC-ND licensed set of five mods by Keith Baylis/Vim! for testing purposes
  # Mods from Mod Soul Brother: https://web.archive.org/web/20120215215707/http://www.mono211.com/modsoulbrother/vim.html
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
