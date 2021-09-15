class Sdlpop < Formula
  desc "Open-source port of Prince of Persia"
  homepage "https://github.com/NagyD/SDLPoP"
  url "https://github.com/NagyD/SDLPoP/archive/v1.22.tar.gz"
  sha256 "1af170f7f6def61b2ab9c3a9227feca335461d224faa99f3578fc09115ac505c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "1ccdaf2e5186bcc2d0094fbdc59206c5b602b367287ee76a3473969897f1af8a"
    sha256 cellar: :any,                 big_sur:       "2c3a47b467b2bdd321d1b7f2d73ad7f40859319b2ae6b51ef0009c2274c2581b"
    sha256 cellar: :any,                 catalina:      "4c2307714ee64456baac5c4b758e48c8aca6747a0daa92b8bc31fd1597663250"
    sha256 cellar: :any,                 mojave:        "d304d506f73fec8e98b223eb0f8cfd087dd7a15a144fd0b46522f7a2b78261b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a9e40fba4560043c8f5b190a51f5b4d2be4ebc4f48b6cdab8d49c7dddc9814e"
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "sdl2_image"

  # Fix SDL2 header search location during build. Patch accepted upstream, remove on next release.
  patch do
    url "https://github.com/NagyD/SDLPoP/commit/26d3fb9ffee2831ab98b1f0359ba25b41f6fffc8.patch?full_index=1"
    sha256 "4c62ddef19d5550f3dc0db6d5a2fff7ba2c2454d376ca624a147b4c650512097"
  end

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
