class Sdlpop < Formula
  desc "Open-source port of Prince of Persia"
  homepage "https://github.com/NagyD/SDLPoP"
  url "https://github.com/NagyD/SDLPoP/archive/v1.20.tar.gz"
  sha256 "dbb75398dee2224bcee648602ad23e469b936a2b7ea962a8a01b091b989f25b6"

  bottle do
    cellar :any
    sha256 "54fd6bcb8f351a98cd38017bb3c2a6df7a607dbd13b32cbd2162ab168a2a7759" => :catalina
    sha256 "136ad2e3a3dfb37fa6e998ebcada2b35f1a41b8b31b4ac404038388bd2d6902b" => :mojave
    sha256 "40e3329a4043ea4da4e71ccfbea3c9f710e9fed5d61e1d91a5390f7505f6c5f5" => :high_sierra
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

  def caveats
    <<~EOS
      Save and replay files are stored in the following directory:
        #{var}/sdlpop
    EOS
  end
end
