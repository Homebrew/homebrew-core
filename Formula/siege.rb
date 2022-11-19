class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege-home/"
  url "http://download.joedog.org/siege/siege-4.1.5.tar.gz"
  sha256 "076df9fcdb7f63c46d6f661acc2ccc8405937ae9cae490ab8a9d78a9d2e7b8cb"
  license "GPL-3.0-or-later"

  livecheck do
    url "http://download.joedog.org/siege/?C=M&O=D"
    regex(/href=.*?siege[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "18f9e238472e25cce932c07d55b8b729e75e705afdc027cfc81d9ef70ba01791"
    sha256 arm64_monterey: "d235a15e372f838506ae4fab062d4261a11e33486e3beaf51213f6025d0cf15b"
    sha256 arm64_big_sur:  "5f690bc46956dfe6ff66886a20729d6b1d9abaac77fa06df2a16476c6bcc76d0"
    sha256 ventura:        "c1ab26ae84904f676709989c6a19c3e41972e53ba57b8645837d6318605b6a3b"
    sha256 monterey:       "f488d7149a9b1bceb4f31c071890c3147e9d8a756be9286a299f3e44a9a7c4e6"
    sha256 big_sur:        "0be515369bcf7a3fa189a60040decfcc494633cc4d38fcf2114259a82f6f0cfb"
    sha256 catalina:       "c37662f2c1f706c017c4c17d7ae2fd4bc858146683d1c682337d566b499d8c1b"
    sha256 x86_64_linux:   "a98e6f0d66599e9e9470728bc0dc3a8c7e73dc1dcdc126f1fd49aaf902f41974"
  end

  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # To avoid unnecessary warning due to hardcoded path, create the folder first
    (prefix/"etc").mkdir
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--localstatedir=#{var}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
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
