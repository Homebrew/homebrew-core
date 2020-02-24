class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege-home/"
  url "http://download.joedog.org/siege/siege-4.0.5.tar.gz"
  sha256 "3b4b7001afa4d80f3f4939066a4932e198e9f949dcc0e3affecbedd922800231"

  bottle do
    sha256 "6a1df0da2bd5bdbdc6264fa49c4b0ddb44a2a3eb9f6dd275773e45529981ef46" => :catalina
    sha256 "eb50a8806bb8113d7d59c56da107687cece5289cc69ceebc020601e760a35946" => :mojave
    sha256 "8597b370f2997d538cdeefe66f6020b39aaccb2d689f8499fc4070c5a0aaf5df" => :high_sierra
  end

  depends_on "openssl@1.1"

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
