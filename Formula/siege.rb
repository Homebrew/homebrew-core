class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege-home/"
  url "http://download.joedog.org/siege/siege-4.0.4.tar.gz"
  sha256 "8f7dcf18bd722bb9cc92bc3ea4b59836b4a2f8d8f01d4a94c8d181f56d91ea6f"

  bottle do
    sha256 "975fa6c60a27b9462d55ef7b4e9faeec0569de3b48bd10dab89c88a001350459" => :mojave
    sha256 "a5e4990ab448ec37e9e5e7b392a7bf6aee03313bad6d89c6fda45decd4ddecf4" => :high_sierra
    sha256 "84ad0232db938f558c2ad57b5c61382b136483c3d4f106f6fcea7e647d2b9982" => :sierra
    sha256 "4ffac4100438cc7d6784a64774770ffe219bf330e96890c77eb012bab0f02ba5" => :el_capitan
  end

  depends_on "openssl"

  def install
    # To avoid unnecessary warning due to hardcoded path, create the folder first
    (prefix/"etc").mkdir
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--localstatedir=#{var}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    macOS has only 16K ports available that won't be released until socket
    TIME_WAIT is passed. The default timeout for TIME_WAIT is 15 seconds.
    Consider reducing in case of available port bottleneck.

    You can check whether this is a problem with netstat:

        # sysctl net.inet.tcp.msl
        net.inet.tcp.msl: 15000

        # sudo sysctl -w net.inet.tcp.msl=1000
        net.inet.tcp.msl: 15000 -> 1000

    Run siege.config to create the ~/.siegerc config file.
  EOS
  end

  test do
    system "#{bin}/siege", "--concurrent=1", "--reps=1", "https://www.google.com/"
  end
end
