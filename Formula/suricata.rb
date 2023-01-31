class Suricata < Formula
  desc "Network IDS, IPS, and security monitoring engine"
  homepage "https://suricata.io"
  url "https://www.openinfosecfoundation.org/download/suricata-6.0.10.tar.gz"
  sha256 "59bfd1bf5d9c1596226fa4815bf76643ce59698866c107a26269c481f125c4d7"
  license "GPL-2.0-only"

  livecheck do
    url "https://suricata.io/download/"
    regex(/href=.*?suricata[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "d6fb86fc95a8228adb9ba8b38fce0c81b6e700b897ec7ba50225506bc020b3b6"
    sha256 arm64_monterey: "032abfbeebd3649e359ab2871d791fcdb3646d24cb36cc94705ab5dce55730ae"
    sha256 arm64_big_sur:  "25d85da00add941ac3b3a2f94d8c034d3f13cb2ca77b545acea5288722c4921a"
    sha256 ventura:        "709efdf883a679bc020ab7c17a398685c0b1f894f1465e8c3e4b2f2dd6c2550b"
    sha256 monterey:       "ada66b413ebac219df51d43f55f133ae01e04f83f41e72d0c9729f3cb5d8326f"
    sha256 big_sur:        "97e1cf955c65d8b12db57afd39e02381666a95088e8173444168bfe2667e93be"
    sha256 x86_64_linux:   "8adeda897c08b18f856c107ca051755834ad01677ed9bdb670c51a93a396836a"
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

    inreplace "configure", "for ac_prog in python3 ", "for ac_prog in python3.11 "
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
