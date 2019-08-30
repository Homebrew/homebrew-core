class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege-home/"
  url "http://download.joedog.org/siege/siege-4.0.4.tar.gz"
  sha256 "8f7dcf18bd722bb9cc92bc3ea4b59836b4a2f8d8f01d4a94c8d181f56d91ea6f"
  revision 2

  bottle do
    sha256 "8a057346938d661b2a4b2cf6523da41a76bdc9a26b76953b3e301763f1b1c804" => :mojave
    sha256 "2313774da1f8716dd225cfe13b12808ad23af54ffa2d477dd90bdd7bef16380c" => :high_sierra
    sha256 "3ce11d6b7f693f0f3da024c7e8a1341d57b21d532bef16f414064300998fcedb" => :sierra
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
