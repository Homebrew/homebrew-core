class TtyClock < Formula
  desc "Analog clock in ncurses"
  homepage "https://github.com/xorg62/tty-clock"
  url "https://github.com/xorg62/tty-clock/archive/v0.1.tar.gz"
  sha256 "866ee25c9ef467a5f79e9560c8f03f2c7a4c0371fb5833d5a311a3103e532691"
  head "https://github.com/xorg62/tty-clock.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3939d783a09c4717bd02169ef6d074cc3ae9551e87743b3576510978d6bd6553" => :sierra
    sha256 "421eaa195f1dc55ec1af56ed7d3ab1825d94ddfebe2276b667afeae59e68d78e" => :el_capitan
    sha256 "51cf833ee7f7bfb6539d804c9df571be0ec010886128c7bef8ce3cd53dd478ac" => :yosemite
    sha256 "82cc2ecb173ecc895ce117f765bcda7e20d911abb63db5c9ffe9339aa2054a1a" => :mavericks
  end

  def install
    inreplace "Makefile", "/usr/local/bin/", "#{bin}/"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/tty-clock -i"
  end
end
