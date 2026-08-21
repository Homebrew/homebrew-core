class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege"
  url "https://download.joedog.org/siege/siege-4.2.0.tar.gz"
  sha256 "78af482fc655f1cf7270fdbc3171581ed4cb3163009f7f4f056fc2b7e2d24453"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.joedog.org/siege/?C=M&O=D"
    regex(/href=.*?siege[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3186ecf8ef3b546c3b2bb32dc002c954e66d093b7a7448fd78e5adaf923a8d24"
    sha256 arm64_sequoia: "ecd09a37f6ffb889db49b639abc0d2f3178a66c53cd5a1b0254a8c3eab96fdd0"
    sha256 arm64_sonoma:  "ec7d129c7ebecabd7dbf124362ebf27fd0d5efb2e88b5080f7e7203afa6798b3"
    sha256 sonoma:        "d82d56e7d981fa198ee87a7f35cc2676e0b92ca10a9cadc02514eda7113ec0d3"
    sha256 arm64_linux:   "efa16f2f8c71eb84d4e98ead888de7d2aab940e95dfe19bd40a3960de22b6f89"
    sha256 x86_64_linux:  "770a4c20b41bcd77a748cd667255508b882bd1449440799104a950058ce38635"
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # workaround for newer clang
    # notified upstream on the site on 2024-09-10
    ENV.append_to_cflags "-Wno-int-conversion" if DevelopmentTools.clang_build_version >= 1403

    # To avoid unnecessary warning due to hardcoded path, create the folder first
    (prefix/"etc").mkdir

    zlib = OS.mac? ? "#{MacOS.sdk_path}/usr" : formula_opt_prefix("zlib-ng-compat")
    args = %W[
      --localstatedir=#{var}
      --with-ssl=#{formula_opt_prefix("openssl@4")}
      --with-zlib=#{zlib}
    ]

    system "./configure", *args, *std_configure_args
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
