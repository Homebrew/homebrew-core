class Vitetris < Formula
  desc "Terminal-based Tetris clone"
  homepage "https://www.victornils.net/tetris/"
  url "https://github.com/vicgeralds/vitetris/archive/v0.59.0.tar.gz"
  sha256 "8a3fd7ad6cef51eb49deb812d2bf2c9489647115fdf95506657cf9d7361b1f54"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a773e9655aa93819f5c96d08925c12797a3540975e28b00de8c1d42d4e3a454" => :big_sur
    sha256 "1ced40dfe35a80d2820ea3875024b27d31b590a94ac1cc5ca5b6d6ef7e9fd679" => :catalina
    sha256 "fadb41e0b7ad861cec4883c148c2cfc6ebe52e8a3b4eb099a3ffcb4cd07e5936" => :mojave
  end

  def install
    # remove a 'strip' option not supported on OS X and root options for
    # 'install'
    inreplace "Makefile", "-strip --strip-all $(PROGNAME)", "-strip $(PROGNAME)"

    system "./configure", "--prefix=#{prefix}", "--without-xlib"
    system "make", "install"
  end

  test do
    system "#{bin}/tetris", "-hiscore"
  end
end
