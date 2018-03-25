class Sdlpop < Formula
  desc "Open-source port of Prince of Persia"
  homepage "https://github.com/NagyD/SDLPoP"
  url "https://github.com/NagyD/SDLPoP/archive/v1.18.1.tar.gz"
  sha256 "8032c47fad4b73021d636ead510bbc1ab5106cff77103e331ad0f32a49a13946"

  bottle do
    cellar :any
    sha256 "6925668670d825fcdcbf83816e0e889fd9ed9056cde2da28a392c34424a6a7dc" => :high_sierra
    sha256 "c3845ce9e1adb1336bcd99513873fecfb498612c03877d18cde43ea749991c8b" => :sierra
    sha256 "8a1edf5d1acb9adaadc29b14eb637b8d0bfbccc88cf777b514a303b792cc5ef5" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

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

  def caveats; <<~EOS
    Save and replay files are stored in the following directory:
      #{var}/sdlpop
    EOS
  end
end
