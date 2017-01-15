class TtyClock < Formula
  desc "Analog clock in ncurses"
  homepage "https://github.com/xorg62/tty-clock"
  url "https://github.com/xorg62/tty-clock/archive/v2.3.tar.gz"
  sha256 "343e119858db7d5622a545e15a3bbfde65c107440700b62f9df0926db8f57984"
  head "https://github.com/xorg62/tty-clock.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3939d783a09c4717bd02169ef6d074cc3ae9551e87743b3576510978d6bd6553" => :sierra
    sha256 "421eaa195f1dc55ec1af56ed7d3ab1825d94ddfebe2276b667afeae59e68d78e" => :el_capitan
    sha256 "51cf833ee7f7bfb6539d804c9df571be0ec010886128c7bef8ce3cd53dd478ac" => :yosemite
    sha256 "82cc2ecb173ecc895ce117f765bcda7e20d911abb63db5c9ffe9339aa2054a1a" => :mavericks
  end

  depends_on "pkg-config" => :build

  def install
    ENV.append "LDFLAGS", "-lncurses"
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/tty-clock", "-i"
  end
end
