class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.23.2.tar.gz"
  sha256 "a9a94cc5bfb8b067fa98061ac3465f3477f410e0eebe3ca004fb884e173637b4"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :homepage
    regex(%r{".*?/silk[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "770c1fb5e359e0aa86a67f0697bf980cffadc6e3127da5115898df8b2bf848d2"
    sha256 arm64_sonoma:  "d7793295db904c7096cf967aad6a4bed6c210ab76f2522a465047151ddaecd08"
    sha256 arm64_ventura: "04c95251e372b4978e9a2dd179c33f0351cf49e3aaa7f65102dd0ba6883d7add"
    sha256 sonoma:        "67dc5c2fd2f92e1a4275eb810ad021199869f97a2632e05e761e317bd12c15ad"
    sha256 ventura:       "80a78f717080e8fce59b090ceb166694c5361c3eff7f8fdf654c8a20295cf55d"
    sha256 arm64_linux:   "7cb03c7f98e2db37e7beda6e720038f50351237e478fe091bc485b07c1b42597"
    sha256 x86_64_linux:  "526335372add2a32e3897c606ff00edab0b963ba727638d406e806777d64159b"
  end

  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "yaf"

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "openssl@3"
  end

  def install
    args = %W[
      --mandir=#{man}
      --enable-ipv6
      --enable-data-rootdir=#{var}/silk
    ]
    # Work around macOS Sonoma having /usr/bin/podselect but Pod::Select was
    # removed from Perl 5.34 resulting in `Can't locate Pod/Select.pm in @INC`
    args << "ac_cv_prog_PODSELECT=" if OS.mac? && MacOS.version == :sonoma

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    (var/"silk").mkpath
  end

  test do
    input = test_fixtures("test.pcap")
    yaf_output = shell_output("yaf --in #{input}")
    rwipfix2silk_output = pipe_output("#{bin}/rwipfix2silk", yaf_output)
    output = pipe_output("#{bin}/rwcount --no-titles --no-column", rwipfix2silk_output)
    assert_equal "2014/10/02T10:29:00|2.00|1031.00|12.00|", output.strip
  end
end
