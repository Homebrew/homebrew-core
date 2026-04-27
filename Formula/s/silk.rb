class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.24.1.tar.gz"
  sha256 "0754452f7eadc91d994476e9ce187fe5fce625d8696b7791e545f77df9a9f806"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :homepage
    regex(%r{".*?/silk[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "2e896564119cb4757ed6a08ff3f9cef733389f81067cfd08652ecdc9d2866bd9"
    sha256 arm64_sequoia: "bfcd63d517d1fef97f0531ea45072fcce870effe5676bf028d2cb2f7fdfdcace"
    sha256 arm64_sonoma:  "feece6ada07156e3febf965f42cbdef1c02e4bdaa64fbc2afa1aca6a1dc88671"
    sha256 sonoma:        "90e70d0d59b9ad869265864caa8446e82f40c651ea9511fea7821fabedca35fb"
    sha256 arm64_linux:   "6b1a7e640339ff8b2dfe458471e9a280d56dc4916f13470fea3055c2dd06e4ef"
    sha256 x86_64_linux:  "a25546f8eb9fca55b655e297511d1715da5f95c1a2651ed4f8bf7ac6621e6292"
  end

  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "yaf"

  uses_from_macos "libpcap"

  on_macos do
    depends_on "gettext"
    depends_on "openssl@3"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
