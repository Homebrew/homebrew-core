class Sdlpop < Formula
  desc "Open-source port of Prince of Persia"
  homepage "https://github.com/NagyD/SDLPoP"
  url "https://github.com/NagyD/SDLPoP/archive/v1.19.tar.gz"
  sha256 "e43e3a215e1377d74375fc06183cda76195328a0348a980a5991f3648bb91be2"

  bottle do
    cellar :any
    sha256 "a10a88b0fabec9c095c13f0e870ba5e5417b24c8b9712ab04e4cc243aa30d9b3" => :mojave
    sha256 "7d65b2aeda0577a96a4b24664c7b272bc91ab7ddda0e464d47a1a6ee389e4d45" => :high_sierra
    sha256 "45f4786672fa1f2d4879c00887138c9fb2f778b344223b0eb4ab8a77f8a0a630" => :sierra
    sha256 "32a0513366830e5082ceae4e48286a5817e391b101c64cc4f015c774feeb076e" => :el_capitan
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
