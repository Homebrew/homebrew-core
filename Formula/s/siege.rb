class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege"
  url "https://download.joedog.org/siege/siege-4.1.7.tar.gz"
  sha256 "ec140cedd159979383d60dbe87a0151c2c12ada78791095a8fa84ae635b93026"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.joedog.org/siege/?C=M&O=D"
    regex(/href=.*?siege[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "322ae54214a25c55311e3e2f1aa930c2fd54ea02f0274fbd4e0cc5b9ab8387c4"
    sha256 arm64_sequoia: "2675e2c6b50a3f4257710468d6bfad23be161161659e66260f4090763590e4d7"
    sha256 arm64_sonoma:  "524d5bf687c5adc7affb917cf3e4bb6a58b3c0510f162f829c14e8b39d53e19e"
    sha256 sonoma:        "3017a5bbaa9663d5bdbabb8b169cd8420b8ae20203d82961ef2a1debb6f7a5cc"
    sha256 arm64_linux:   "9284ea04070d1d998f6d1e2cd6e5fb8eb596f4ee26c60cdc32b146f37a757917"
    sha256 x86_64_linux:  "6f02cca62e76799c557d000eb640f5772d666572241bc2b9a5c05e23aa32b76b"
  end

  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # workaround for newer clang
    # notified upstream on the site on 2024-09-10
    ENV.append_to_cflags "-Wno-int-conversion" if DevelopmentTools.clang_build_version >= 1403

    # To avoid unnecessary warning due to hardcoded path, create the folder first
    (prefix/"etc").mkdir

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--mandir=#{man}",
      "--localstatedir=#{var}",
      "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
    ]
    args << "--with-zlib=#{MacOS.sdk_path_if_needed}/usr" if OS.mac?

    system "./configure", *args
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
    system bin/"siege", "--concurrent=1", "--reps=1", "https://www.google.com/"
  end
end
