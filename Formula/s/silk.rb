class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.24.0.tar.gz"
  sha256 "9292f6c90cd324e2dde58faa77e74cacd1398c27b5cd6bc3f194409b07c4affc"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :homepage
    regex(%r{".*?/silk[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "f5c12c20f91441e12dd6eb5acbb82bfebe2fb02a7b55439b46771671b12b679e"
    sha256 arm64_sequoia: "f80f816542d3df0d4c3b0e878eec959bcc568b40c4252e84bfde847046629ff2"
    sha256 arm64_sonoma:  "6c0999ed8b38a973542d47d7481ae0007d3241e4ed8e219b58bb10c644428f96"
    sha256 arm64_ventura: "be0e97681f03a557f16902466621eba29811467fb5e973d62a4ce5fdfcc2c4e9"
    sha256 sonoma:        "0c7093ddc5b13575c291fbad36c456f99a838471e72042d8646c6ec5e00722b4"
    sha256 ventura:       "877a85d27e621f0fa2c5065912321380699fe3d8b4c2a5f429f6d9f8bcf49239"
    sha256 arm64_linux:   "451b975475964804e7ae109fb016c993dcf877443830424f4bc0b3dab0568ebb"
    sha256 x86_64_linux:  "f60f3e2ff207a72229d680c49100a12047c4070c0e06d11dd60a60a3c3d86d20"
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
