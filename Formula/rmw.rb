class Rmw < Formula
  desc "OS portable cli trash can utility written in C"
  homepage "https://github.com/andy5995/rmw/wiki"
  url "https://github.com/andy5995/rmw/archive/v0.4.03.tar.gz"
  sha256 "5b08fce4392901d7900bfbd65bd8794a1bf9b6700073bc48ed8e88d6185c4177"

  depends_on "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rmw", "-V"
  end
end
