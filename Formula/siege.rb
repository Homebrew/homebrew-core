class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege-home/"
  url "http://download.joedog.org/siege/siege-4.0.9.tar.gz"
  sha256 "1dbe15860569e7becedfefca6cd60d1fdba2eed281098e51718ca70d2575f277"
  license "GPL-3.0"

  livecheck do
    url "http://download.joedog.org/siege/?C=M&O=D"
    regex(/href=.*?siege[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "1b7fdd7383aa8707ea7a82873a2e68338adc8c01bc5b6af2664738ffc448fad1"
    sha256 big_sur:       "4e6fa02afc086f8f0426d071c9e773ac51b0c02ac9864ddcbb89c67ce33aa8d3"
    sha256 catalina:      "8af4b0fe458e6fb3d07196f68b454d4fe47c509b693867435b6d9485a260dfdf"
    sha256 mojave:        "1ccea122394d064b6edc165cbe4199356c8672d512129fb9908e669759661682"
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
