class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.23.1.tar.gz"
  sha256 "c3277352764fa9167a6130739bd4b7cc8ebcb7b7d4f727b46facd7b135f26c23"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :homepage
    regex(%r{".*?/silk[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "9174f223744ea5a48b59a4ab66269bb36e0033cbd9925a248120708b33522eb0"
    sha256 arm64_sonoma:  "df1f4e0f33fcf049b18992fb1a84323c9891339dd66bc6f9ea0d18405e97c6da"
    sha256 arm64_ventura: "676fbf5554b1e229f629728f296ea6fa5f99080bf27745ce7af7f95c24f0a441"
    sha256 sonoma:        "37d538756d940202a4319f73ce6d67011091bebd12aabeeecd3900edf854d9ba"
    sha256 ventura:       "e3200fa12fbbe0cad5b28db61d65e73269abb80ab21396e1607783d0caf432e1"
    sha256 x86_64_linux:  "41438d609da5625f2a222397a1e8e5e85c82d2fe5aed69192e5b82394f52ebc0"
  end

  depends_on "pkg-config" => :build

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
