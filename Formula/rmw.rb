class Rmw < Formula
  desc "OS portable cli trash can utility written in C"
  homepage "https://github.com/andy5995/rmw/wiki"
  url "https://github.com/andy5995/rmw/archive/v0.4.01.tar.gz"
  sha256 "3e53d7c52e2a144f97bbda5ebba51548d3a33cc3f2d37193d9b7e055c4e9d03c"

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
