class Sdlpop < Formula
  desc "Open-source port of Prince of Persia"
  homepage "https://github.com/NagyD/SDLPoP"
  url "https://github.com/NagyD/SDLPoP/archive/v1.17.tar.gz"
  sha256 "aa4b254ab80b889a6db491b41c4f83467124d932cc0836e5979fa73b6c49a94d"

  bottle do
    cellar :any
    sha256 "8b93f508885eaee3c4ae19ddf742c300cab759071e121b2ff2a8c71f8a7f0b45" => :sierra
    sha256 "73421230b4c191a3a61432d176a59282459be5319a5f71e5b8ac14b49b1f2a82" => :el_capitan
    sha256 "f072b31c910a2f88ba2ad51b380d55ab4be4279807e4362353d48099b083417f" => :yosemite
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
