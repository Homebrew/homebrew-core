class Suricata < Formula
  desc "Network IDS, IPS, and security monitoring engine"
  homepage "https://suricata.io"
  url "https://www.openinfosecfoundation.org/download/suricata-6.0.9.tar.gz"
  sha256 "3225edcbd0277545b7128df7b71652e6816f3b4978347d2f4fe297d55ed070e8"
  license "GPL-2.0-only"

  livecheck do
    url "https://suricata.io/download/"
    regex(/href=.*?suricata[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0e132e5120dab6747abdab31c098d14afe7fb4372e8639a2d0c9e9b71033f19b"
    sha256 arm64_monterey: "f6bba507bece50bc56d8995bc00369c4e30d85156bbf5cbb7fe95af7f5105126"
    sha256 arm64_big_sur:  "32d9efc6fb46f897b9fa19909faa2fa57bc41fd821413ea7de7fcfa82622f6bb"
    sha256 ventura:        "01f4f4eb7ea55be7c66ea4c45f30be5d7d5aa52434c9e45a820b4f4bfdb0bfcb"
    sha256 monterey:       "8600dfa9367fa03e9a6fafeeb308e1e231fb5e3be79add2aa8cf40e3ce367b5c"
    sha256 big_sur:        "e1b683285578bce6e93bbdfc0ff7943f3be2d12295af4974becfdee77d004fe6"
    sha256 catalina:       "ced864e6364efecb07fe97dce1f5cb4efcf17db57c97d6c141df7a95aa71d513"
    sha256 x86_64_linux:   "487ca07ddbfae1e396ff9353b6ba2b4803f54a1d549d57349aa81b8b3364d9df"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "libnet"
  depends_on "lz4"
  depends_on "nspr"
  depends_on "nss"
  depends_on "pcre"
  depends_on "python@3.11"
  depends_on "pyyaml"

  uses_from_macos "libpcap"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    directory "libhtp"
  end

  def install
    jansson = Formula["jansson"]
    libmagic = Formula["libmagic"]
    libnet = Formula["libnet"]

    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-libjansson-includes=#{jansson.opt_include}
      --with-libjansson-libraries=#{jansson.opt_lib}
      --with-libmagic-includes=#{libmagic.opt_include}
      --with-libmagic-libraries=#{libmagic.opt_lib}
      --with-libnet-includes=#{libnet.opt_include}
      --with-libnet-libraries=#{libnet.opt_lib}
    ]

    if OS.mac?
      args << "--enable-ipfw"
      # Workaround for dyld[98347]: symbol not found in flat namespace '_iconv'
      ENV.append "LIBS", "-liconv" if MacOS.version >= :monterey
    else
      args << "--with-libpcap-includes=#{Formula["libpcap"].opt_include}"
      args << "--with-libpcap-libraries=#{Formula["libpcap"].opt_lib}"
    end

    system "./configure", *std_configure_args, *args
    system "make", "install-full"

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: lib/"suricata/python")

    # Leave the magic-file: prefix in otherwise it overrides a commented out line rather than intended line.
    inreplace etc/"suricata/suricata.yaml", %r{magic-file: /.+/magic}, "magic-file: #{libmagic.opt_share}/misc/magic"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/suricata --build-info")
    assert_match "Found Suricata", shell_output("#{bin}/suricata-update list-sources")
  end
end
