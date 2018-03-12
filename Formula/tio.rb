class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v1.29/tio-1.29.tar.xz"
  sha256 "371a11b69dd2e1b1af3ca2a1c570408b1452ae4523fe954d250f04b6b2147d23"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/tio -h", 0)
  end
end
