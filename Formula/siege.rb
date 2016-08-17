class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege-home/"
  url "http://download.joedog.org/siege/siege-4.0.2.tar.gz"
  sha256 "7efb81f9547bef0e693bdd51348a205ad691e1d72c36041f4608099ba0326c47"

  bottle do
    sha256 "e0cfb14f0f2dad3fb3514bc4ceeae6ee137797dcd4f030f000464079a189bf1e" => :el_capitan
    sha256 "559f879db66339deee11d3c56d9901ba4f234369c50ffb5f4e63555de4ca4f05" => :yosemite
    sha256 "2dcd1922340050f44e0f6f5c145d3f9932db5058fd1743bf6af8864026fab88e" => :mavericks
  end

  depends_on "openssl"

  def install
    # To avoid unnecessary warning due to hardcoded path, create the folder first
    (prefix/"etc").mkdir
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--localstatedir=#{var}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Mac OS X has only 16K ports available that won't be released until socket
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
