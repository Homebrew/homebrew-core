class Schismtracker < Formula
  desc "Portable reimplementation of Impulse Tracker"
  homepage "http://schismtracker.org/"
  url "https://github.com/schismtracker/schismtracker/archive/20170420.tar.gz"
  sha256 "bfc46da6a1328b67ae165bcdebacc8aa7d03b9f76346fdebc1caab2462de064c"
  head "https://bitbucket.org/Storlek/schismtracker", :using => :hg

  bottle do
    cellar :any
    sha256 "6c3b2141b86225999879a5fe1998ad2cee0ed4b68df0cf694ec74134f79fd558" => :sierra
    sha256 "b5e2011b7b5c57513f114ec3a5ca18eb8cbe9bbc3e0316a7be0662c99e38cd0f" => :el_capitan
    sha256 "b31294832db7d4eaa4390a8584ff2678616bee690f950644f8f3f81535070303" => :yosemite
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
