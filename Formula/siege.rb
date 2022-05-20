class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege-home/"
  url "http://download.joedog.org/siege/siege-4.1.3.tar.gz"
  sha256 "2250bca8fca539f1a4e4cbe5ba89afd32c4739b2fbc60c7ca6168d9a782f790a"
  license "GPL-3.0-or-later"

  livecheck do
    url "http://download.joedog.org/siege/?C=M&O=D"
    regex(/href=.*?siege[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "463170796c52f7651386b889298f25e249fa8d4d03dbc9090a01069e2f2124fc"
    sha256 arm64_big_sur:  "84588fcd2627114af6e79ea402e1195885204d2ab47e1c2d7ba6032a5196ed50"
    sha256 monterey:       "576231668f70ff5a63041e862727db42553d976748a112e03bd88fccd4849f76"
    sha256 big_sur:        "c94fa95c94c212539d98615cc2001e074de0be743e6bd31801bbdccabcb0ab81"
    sha256 catalina:       "db47466f69c5e7c6737099424a4c4e1139ad487c0f2380ee80ce8f530f0711b4"
    sha256 x86_64_linux:   "908d5fb2d6ec753c8061c35c7a3fa7ea383257ae649bd68e634c99620ac65b16"
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
