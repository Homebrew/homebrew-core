class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege-home/"
  url "http://download.joedog.org/siege/siege-4.0.7.tar.gz"
  sha256 "bfa75b3eaad372e7b89eee75d789cd6acbda34900a0c6e49030cf0f803b56df8"
  license "GPL-3.0"

  livecheck do
    url "http://download.joedog.org/siege/?C=M&O=D"
    regex(/href=.*?siege[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "77c2687b1ae0baf1d035a369ecc8c2d67eff4d38ee1d84ee434e33702fbce5a4"
    sha256 big_sur:       "7efea2f148c0b6323fa3b605b57bb5122cbe042626b0e0e059b697cf65c78207"
    sha256 catalina:      "52d3c7d5f18591e84a8407281a48e5dfb449f2e5c0628edb8b0998470414d4b7"
    sha256 mojave:        "f505c43ad4aa79798c14ee1df2fdeea2ffe62588e1dfd1928fc0eddb385497a5"
  end

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    # To avoid unnecessary warning due to hardcoded path, create the folder first
    (prefix/"etc").mkdir
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--localstatedir=#{var}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--with-zlib=#{MacOS.sdk_path_if_needed}/usr"
    system "make", "install"
  end

  def caveats
    <<~EOS
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
