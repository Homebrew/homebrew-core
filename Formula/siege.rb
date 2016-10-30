class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege-home/"
  url "http://download.joedog.org/siege/siege-4.0.2.tar.gz"
  sha256 "7efb81f9547bef0e693bdd51348a205ad691e1d72c36041f4608099ba0326c47"

  bottle do
    sha256 "727ee17ca64eb752916cf8318d0cda9a56b094d358b46b04b33d66872373f843" => :sierra
    sha256 "787e7394cc038b1a06d164faebbb0b02a37f32757abbf80da223d46b0f0091e5" => :el_capitan
    sha256 "932fce124172f3b1e25bfcbe673feffccf1a86ea97f00564ecaeb01f4950d3bb" => :yosemite
    sha256 "6575d3bc644e7acecbeab9b7c8fed77c7c523a709e9b2184501b2d40c7eb8d5f" => :mavericks
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
