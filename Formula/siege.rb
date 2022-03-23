class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege-home/"
  url "http://download.joedog.org/siege/siege-4.1.2.tar.gz"
  sha256 "e472abe19c5a93f6be5bfd64dff26f668da2c6d210af8213b60c9c0db17eca79"
  license "GPL-3.0-or-later"

  livecheck do
    url "http://download.joedog.org/siege/?C=M&O=D"
    regex(/href=.*?siege[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "be440f6540a10977b1c5d7b6406fba6912d1180f02166a182bcdb36d1f19cd68"
    sha256 arm64_big_sur:  "bc2eb934f93364fa2bf0e19778df12a07e52bab918b723cd6e2165368cdcdc9d"
    sha256 monterey:       "69201e329616cc0f6c3b1b96f83f3082bae76933fc32245902761219c2fde29c"
    sha256 big_sur:        "1cef6df6277b9a7e8365777d33fdc93001bf018b0f84c914e4acfb4cba2f489f"
    sha256 catalina:       "8f0fe495d1c2f315fbd264cd46c96df2deb4c637c8107da8add5571d91a655f8"
    sha256 x86_64_linux:   "ef1e5a8d7ca1ad4b4bbf0ea5b19f68e75a69b61661cc3efcb4742b66830eb52e"
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
