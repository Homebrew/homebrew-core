class Sdlpop < Formula
  desc "Open-source port of Prince of Persia"
  homepage "https://github.com/NagyD/SDLPoP"
  url "https://github.com/NagyD/SDLPoP/archive/v1.17.tar.gz"
  sha256 "aa4b254ab80b889a6db491b41c4f83467124d932cc0836e5979fa73b6c49a94d"

  bottle do
    cellar :any
    sha256 "a3ccd5802afa6e011c1fee322cdf0eee972124d2e33b3cf92fca9f62b4b74644" => :sierra
    sha256 "8b3ae1c63ef4f92291e251ed1aeb2fd528a4189f4f282cfa1121bfef3353dca0" => :el_capitan
    sha256 "72d5e075f07ce5c4dd3b6789412efa5355f0f54f6cc414abb0799550898b12de" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  def install
    system "make", "-C", "src"
    doc.install Dir["doc/*"]

    # Use var directory to keep save and replay files
    pkgshare.install Dir["data/*.DAT"]
    pkgshare.install "data"
    pkgvar = var/"sdlpop"
    pkgvar.install_symlink Dir["#{pkgshare}/*.DAT"]
    pkgvar.install_symlink pkgshare/"data"
    pkgvar.install "SDLPoP.ini" unless (pkgvar/"SDLPoP.ini").exist?

    # Data files should be in the working directory
    libexec.install "prince"
    (bin/"prince").write <<-EOS.undent
      #!/bin/bash
      cd "#{pkgvar}" && exec "#{libexec}/prince" $@
      EOS
  end

  def caveats; <<-EOS.undent
    Data including save and replay files are stored in the following directory:
      #{var}/sdlpop
    EOS
  end
end
