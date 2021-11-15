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
    sha256 arm64_monterey: "c57f85c927a9a67ab09980855cf2498335ed2a9849bae6eb8eb58ce58bc7db89"
    sha256 arm64_big_sur:  "14c77189b3ea80705dd31c790cd65aca11d8752a5ff60f9f56abc190fb5dd860"
    sha256 monterey:       "01dc1bb6290f7ada1158c978971ebae843e1c58e74aa59716a770286a159baf9"
    sha256 big_sur:        "3a0700e1b41361e960dd0266bde486ab89afb27a706de7d970325889ae39bc7c"
    sha256 catalina:       "45ac6999d1446257c046416c6be4ebea0e8aae69ca49ef6ac2aba2844fde3281"
    sha256 mojave:         "650238923f354fcec454b5bd6219ab26bbb3680d440420216446a3878b382b92"
    sha256 x86_64_linux:   "14d0a4594a88c19185f06de0bc12a626b2dde2740868250bc58312e57dabbc74"
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
