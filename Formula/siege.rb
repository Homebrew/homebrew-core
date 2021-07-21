class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege-home/"
  url "http://download.joedog.org/siege/siege-4.1.1.tar.gz"
  sha256 "143c25727b9bb2c439486c35121602f4d963385305aab4ed1ff9851581bfe4a8"
  license "GPL-3.0-or-later"

  livecheck do
    url "http://download.joedog.org/siege/?C=M&O=D"
    regex(/href=.*?siege[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "b167a82660a06e04af54b8905b035cf235ad0ca9e8213347c62db035b41fedda"
    sha256 big_sur:       "05638d19ffa563cc481eab657c0e736d5d781c40a217011d4d665544801c7aef"
    sha256 catalina:      "a0a699800f7ac139560131786274f5be98df746311f3bee6775f11fdff769890"
    sha256 mojave:        "2a5469ea2ac0139438dc899c479011b91bf39d5115da1dcf4e4d245a17d8a89e"
    sha256 x86_64_linux:  "705bd34131e701e7fbbfde2fccdf6fdbc22b74de15f4df06ad053a1b0f87a24c"
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
