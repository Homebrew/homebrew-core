class Sdlpop < Formula
  desc "Open-source port of Prince of Persia"
  homepage "https://github.com/NagyD/SDLPoP"
  url "https://github.com/NagyD/SDLPoP/archive/v1.19.tar.gz"
  sha256 "e43e3a215e1377d74375fc06183cda76195328a0348a980a5991f3648bb91be2"

  bottle do
    cellar :any
    sha256 "686310fe7699a5e291ea7e05006b4210609c564af7fe5dc7e52bf61fae26400a" => :catalina
    sha256 "b8f410ee151aefc11d905c7ccfff17cee6235988dfd7d2615984fd0ab40a532b" => :mojave
    sha256 "759d1be2124d3cbd23e1364e950eb2a4fdb713da491119e61da269ca2f5c388d" => :high_sierra
    sha256 "74f83f14a15a8f612e7669e29a6ea6d45ff3f3610a31184de02bee11cc32a498" => :sierra
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
