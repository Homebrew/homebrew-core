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
    sha256 arm64_ventura:  "98dd26e0a033653067b8c932ff761cd037b4653feac661e64dc373f86b709a98"
    sha256 arm64_monterey: "4c25cc322a4873186c5d3621af5bc2a1aa1b9bc36bd61d01cbc6e8ffb936381d"
    sha256 arm64_big_sur:  "c4774a5b6fc668aa03d0b8fad53d4e0e736ff475549a77ef1b7b409f370a8bf5"
    sha256 ventura:        "d3e3ead059e1b7f23aaf954c8502ce9e32547878972f992b11337d10c2de9293"
    sha256 monterey:       "bbf2686f1b3664b7a7f4392e74f5748046dac9dd5f25b6c929c34b25610826e6"
    sha256 big_sur:        "bee643fc153e438ec4020c3e7a619cade1bcad2bdf08d25262b5040150bb9abc"
    sha256 catalina:       "2e67988df1c76bb2dbde08064246f94cd7a356ea2273a0ef7a70d2b8ae8aa2d6"
    sha256 x86_64_linux:   "df87d178ad402ff12a7ab1c14100147e4319c3a9227e087b2f148faccb467450"
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
