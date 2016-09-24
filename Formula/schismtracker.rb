class Schismtracker < Formula
  desc "Portable reimplementation of Impulse Tracker"
  homepage "http://schismtracker.org/"
  url "https://bitbucket.org/Storlek/schismtracker/get/20120105.tar.bz2"
  sha256 "736163682c476c2f1afca9b3ebf2a1f5d1a0420dc2da12f2d8cfe6d1b3de379b"
  head "https://bitbucket.org/Storlek/schismtracker", :using => :hg

  bottle do
    cellar :any
    revision 1
    sha256 "390f7f1d0888ee3f3bd39e99cd8a2171be11fa06b6baa12b2dd0a4a0ea4b31bc" => :el_capitan
    sha256 "31f69ea7f490ef49f08508d2cc0e3db5a1d8ed882ae8850689052e407cf95ac9" => :yosemite
    sha256 "4154c14d2d1807e6e757e7b606bfccbc568821eebe33644460c39454cf5f1214" => :mavericks
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
