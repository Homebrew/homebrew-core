class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege-home/"
  url "http://download.joedog.org/siege/siege-4.0.7.tar.gz"
  sha256 "bfa75b3eaad372e7b89eee75d789cd6acbda34900a0c6e49030cf0f803b56df8"
  license "GPL-3.0"

  bottle do
    sha256 "b7de9172ade8285cc5107e598397b6519edee6c1ecf4bb095faa7a1da1346da0" => :catalina
    sha256 "5a0064c051bbd111b8d8723fce3107e41777b223bedffc4e0d0d9da1967e6703" => :mojave
    sha256 "7c4381adab349f46db1445936da393a0f6d007b0f47f3d7660686718b5f9db4e" => :high_sierra
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
