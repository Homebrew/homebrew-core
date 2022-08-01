class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege-home/"
  url "http://download.joedog.org/siege/siege-4.1.4.tar.gz"
  sha256 "ce43df9c7f6b081a84e760b168432519479baeb457b474c097affa5b452a45cb"
  license "GPL-3.0-or-later"

  livecheck do
    url "http://download.joedog.org/siege/?C=M&O=D"
    regex(/href=.*?siege[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "86dc89e34051926f7f8ceb1d042b98c9fca0bcab82d41d8c58dc08f022667a80"
    sha256 arm64_big_sur:  "16ecb40fcc3466adaf71361b31e50b778a137e2217dffe7e356d46bf63411167"
    sha256 monterey:       "76941462c22f1d34051be5b4a819d361875caaa21637b3678d8cc2a2681f2b4e"
    sha256 big_sur:        "364ffeefc5e8332548b2ee0ef68fab8ddd4445fe87dfeba60f7cd7507420b3c3"
    sha256 catalina:       "a1a04b457e895a40d173fc6c6d0a881a5e3f225505017e756ed541289171bc5f"
    sha256 x86_64_linux:   "cb0899120fad21be516bf4a31f6db8e4ed364be6f79f52ce927d6982d8a18e20"
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
