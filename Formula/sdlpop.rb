class Sdlpop < Formula
  desc "Open-source port of Prince of Persia"
  homepage "https://github.com/NagyD/SDLPoP"
  url "https://github.com/NagyD/SDLPoP/archive/v1.23.tar.gz"
  sha256 "41a9aa64b4e8d0a9d7a84ffced48f74f9528d81adbffc08593ecf84776c5d77a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "1ccdaf2e5186bcc2d0094fbdc59206c5b602b367287ee76a3473969897f1af8a"
    sha256 cellar: :any,                 ventura:       "786990712dda58b6dc2e1e7047ad3b24cf7282034e4db22c5d3a28350c701e52"
    sha256 cellar: :any,                 monterey:      "6cdf33d633557c92f89591a24a6600db2485bb78ad1f5f6a8260a7e13f2607c4"
    sha256 cellar: :any,                 big_sur:       "2c3a47b467b2bdd321d1b7f2d73ad7f40859319b2ae6b51ef0009c2274c2581b"
    sha256 cellar: :any,                 catalina:      "4c2307714ee64456baac5c4b758e48c8aca6747a0daa92b8bc31fd1597663250"
    sha256 cellar: :any,                 mojave:        "d304d506f73fec8e98b223eb0f8cfd087dd7a15a144fd0b46522f7a2b78261b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a9e40fba4560043c8f5b190a51f5b4d2be4ebc4f48b6cdab8d49c7dddc9814e"
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "sdl2_image"

  def install
    system "make", "-C", "src"
    doc.install Dir["doc/*"]
    libexec.install "data"
    libexec.install "prince"

    # Use var directory to keep save and replay files
    pkgvar = var/"sdlpop"
    pkgvar.install "SDLPoP.ini" unless (pkgvar/"SDLPoP.ini").exist?

    (bin/"prince").write <<~EOS
      #!/bin/bash
      cd "#{pkgvar}" && exec "#{libexec}/prince" $@
    EOS
  end

  def caveats
    <<~EOS
      Save and replay files are stored in the following directory:
        #{var}/sdlpop
    EOS
  end

  test do
    assert_equal "See doc/Readme.txt", shell_output("#{bin}/prince --help").chomp
  end
end
