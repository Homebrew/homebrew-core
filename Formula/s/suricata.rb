class Suricata < Formula
  desc "Network IDS, IPS, and security monitoring engine"
  homepage "https://suricata.io"
  url "https://www.openinfosecfoundation.org/download/suricata-7.0.3.tar.gz"
  sha256 "ea0742d7a98783f1af4a57661af6068bc2d850ac3eca04b3204d28ce165e35ff"
  license "GPL-2.0-only"

  livecheck do
    url "https://suricata.io/download/"
    regex(/href=.*?suricata[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "809b4d95dcef62769c1760e7d6bdda61814b4baf136ae4c1a3ff68c3bdd8449a"
    sha256 arm64_ventura:  "3c85d806ae4ddda99b50a90d8af38a797eb893ea68d0e19ccc649275537e1ace"
    sha256 arm64_monterey: "892982ab6ab0f8802a3d6002ab50a10396bd863fa3e815f9597dde1798131c5b"
    sha256 sonoma:         "8acb1413d037bc6a20c2584edb11baab6451ca0d7733999f46dd62bb7b2e9c0a"
    sha256 ventura:        "065977357ede5156a659a1199ef3cdd4316822500491a050b218f4575bb523bc"
    sha256 monterey:       "d859b99ef160ecaea338a6a99983250f7bf93d6c737f156a9979c3f2dadc40bd"
    sha256 x86_64_linux:   "5b943c20cfbce30654e0a7587cf872800d8e24e4e4694fc20a659fa28673b050"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "libnet"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "python@3.12"
  depends_on "pyyaml"

  uses_from_macos "libpcap"

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

    inreplace "configure", "for ac_prog in python3 ", "for ac_prog in python3.12 "
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
