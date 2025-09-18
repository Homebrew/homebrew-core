class Sdlpop < Formula
  desc "Open-source port of Prince of Persia"
  homepage "https://github.com/NagyD/SDLPoP"
  url "https://github.com/NagyD/SDLPoP/archive/refs/tags/v1.23.tar.gz"
  sha256 "41a9aa64b4e8d0a9d7a84ffced48f74f9528d81adbffc08593ecf84776c5d77a"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "6e3cea82ac70bf426add75f5a387ca949deda5662ba1dbf3a5e0d22ac4f88270"
    sha256 cellar: :any,                 arm64_sequoia:  "b71553517e9b05d247c8d440606ece9cb18ed9362e2dacdda29ff653158777fb"
    sha256 cellar: :any,                 arm64_sonoma:   "1100bae067cd7cee5b4846be8718e0ecb2a9ada163c97b681cf767be47fc6c8a"
    sha256 cellar: :any,                 arm64_ventura:  "07ea2286bb9e2e5aefd579d7125882d5d744f3e3f7f5bbe1d67ce23242d8463f"
    sha256 cellar: :any,                 arm64_monterey: "5678d9cd2ecb1de029c137d281034b891215f98ee9a2cc47c4597dd7d3467c92"
    sha256 cellar: :any,                 arm64_big_sur:  "985ca9d07147b53562d0402685ab3e7db04803b18fbcaab180d8edacd64f40b8"
    sha256 cellar: :any,                 sonoma:         "305326724cf1be0e0c633a0412110b71c7d06b88c5094ad7c669be8f5c32d510"
    sha256 cellar: :any,                 ventura:        "21793456afcbac882492103a1f0f3b5d2a4b88c26df8df93be46c7ace3d96251"
    sha256 cellar: :any,                 monterey:       "30ac230fb6c1f6fdd28d539c779428b5249e98f3984f4a8aba4ea4eba1038b61"
    sha256 cellar: :any,                 big_sur:        "82fc8922689771f58c21f1fd08f1fc2b39c4cd32aee875c21152178ce5ef448a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9daa7ef72865e7a540bdf684c5e58c59aa510ba5719c361abceac75f401006e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ef6448ced32c9d812689e9103bce4cf3df4eba04d34325898b205438fd73bc8"
  end

  depends_on "pkgconf" => :build
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
    assert_equal "See README.md", shell_output("#{bin}/prince --help").chomp
  end
end
