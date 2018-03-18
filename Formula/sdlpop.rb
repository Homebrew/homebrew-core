class Sdlpop < Formula
  desc "Open-source port of Prince of Persia"
  homepage "https://github.com/NagyD/SDLPoP"
  url "https://github.com/NagyD/SDLPoP/archive/v1.18.tar.gz"
  sha256 "8d232562d2da332c60e0ee0dcba49ad04da6aad259fb91cdd5b669d6efa2a242"

  bottle do
    cellar :any
    sha256 "ec29f073316af5911a6e2d15ef76ff3525888ae1ff78ec148e32f4d674a0f6a7" => :high_sierra
    sha256 "0bfada456be6dd164c3d68a163dc137703d1a75f156b97ae2f218ade92f8aa80" => :sierra
    sha256 "d608ecc22fa9331415976c92af3df5086e8f497c410b8b3c55c787881a5d3e99" => :el_capitan
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
    (bin/"prince").write <<~EOS
      #!/bin/bash
      cd "#{pkgvar}" && exec "#{libexec}/prince" $@
      EOS
  end

  def caveats; <<~EOS
    Data including save and replay files are stored in the following directory:
      #{var}/sdlpop
    EOS
  end
end
