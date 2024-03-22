class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege-home/"
  url "https://download.joedog.org/siege/siege-4.1.6.tar.gz"
  sha256 "309d589bfc819b6f15d2e5e8591b3c0c6f693624f5060eeac067a4d9a7757de9"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.joedog.org/siege/?C=M&O=D"
    regex(/href=.*?siege[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "3726223d7f3dc7001f6f73167e09485babcd706f820270589bd5f3df71904c97"
    sha256 arm64_ventura:  "81ceb978079fb317ee9ed96c9cb5a25630e9047359777d79203210b144dfd8c4"
    sha256 arm64_monterey: "fcbfd35272354e1477efa43d2e908ef07c242995741fbf3edbbba4ed239528d6"
    sha256 arm64_big_sur:  "e210900e7ac3184ebdcc030d147e391c603dd15c7807d8f55b6ed458195467c8"
    sha256 sonoma:         "5805efe17698c2ce1982b9f3efd4ebd6dd2d091039d164e66c382fc4a398672b"
    sha256 ventura:        "fb8ddf6309df48329186c9afd517f845219a970aec991d5aa56ccd2854c0db99"
    sha256 monterey:       "0c9a0511b4b4e5299ba245a7ca1bb4756a80793d9fd04120f0c857a430163544"
    sha256 big_sur:        "b11b9531ea6a4ed3b0a7d2b74c48516765f462b0e65a822a8e9b38ddad8d208a"
    sha256 x86_64_linux:   "323b6373cb6e95b475382543a8d96814d37a22e1c9a817651b6c1e772b766e58"
  end

  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
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
    system "#{bin}/siege", "--concurrent=1", "--reps=1", "https://www.google.com/"
  end
end
