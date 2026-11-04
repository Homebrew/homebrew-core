class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege"
  url "https://download.joedog.org/siege/siege-4.2.2.tar.gz"
  sha256 "c0d5bfac11086aeb3828888a71bf276ed54c9fa0f0af2ead981d2b2fa242141b"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.joedog.org/siege/?C=M&O=D"
    regex(/href=.*?siege[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "e3756d9d1f62cba420dc2df43ac3603467d14f06b0282500122183beb7048440"
    sha256 arm64_tahoe:       "2cdb19baca89915784b97b94d03db26c9dcc6bf0f40fb7f0a2be5396f6cae544"
    sha256 arm64_sequoia:     "85f0075bab6dbc6748b14de742aae5eda40056eccf78cd9c30ee3e0f2d23e4ca"
    sha256 arm64_linux:       "3fd4d02b50048d06549817338fba5195623a203d7e5f032be8758afcca868477"
    sha256 x86_64_linux:      "150eac7765690911ee5ed08cd22786519a382ba7056ad8aa138dc7b7d8e7deae"
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def install
    # workaround for newer clang
    # notified upstream on the site on 2024-09-10
    ENV.append_to_cflags "-Wno-int-conversion" if DevelopmentTools.clang_build_version >= 1403

    # To avoid unnecessary warning due to hardcoded path, create the folder first
    (prefix/"etc").mkdir

    zlib = OS.mac? ? "#{MacOS.sdk_path}/usr" : formula_opt_prefix("zlib-ng-compat")
    args = %W[
      --localstatedir=#{var}
      --with-ssl=#{formula_opt_prefix(openssl)}
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
