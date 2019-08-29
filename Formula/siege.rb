class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege-home/"
  url "http://download.joedog.org/siege/siege-4.0.4.tar.gz"
  sha256 "8f7dcf18bd722bb9cc92bc3ea4b59836b4a2f8d8f01d4a94c8d181f56d91ea6f"
  revision 2

  bottle do
    sha256 "efa8687e655b73e1c890867584a894e2bf3f5b458f3210dd2e4d087eb2185570" => :mojave
    sha256 "6f6ddf745927d9e2b6a60f0c78868a952cb223b4a5ff127c1d165ee1abac9c0d" => :high_sierra
    sha256 "637cbbe464290468705fd46e92ad3e90c60e6e29518591cb33ff33d72e2af3f4" => :sierra
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
