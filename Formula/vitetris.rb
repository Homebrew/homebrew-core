class Vitetris < Formula
  desc "Terminal-based Tetris clone"
  homepage "https://www.victornils.net/tetris/"
  url "https://github.com/vicgeralds/vitetris/archive/v0.59.1.tar.gz"
  sha256 "699443df03c8d4bf2051838c1015da72039bbbdd0ab0eede891c59c840bdf58d"
  license "BSD-2-Clause"
  head "https://github.com/vicgeralds/vitetris.git", branch: "master"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a773e9655aa93819f5c96d08925c12797a3540975e28b00de8c1d42d4e3a454" => :big_sur
    sha256 "6b594a11ce43cd4dc66034d95a4abbe9904fd175bb0045973db8b5cc0a7deee3" => :arm64_big_sur
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
