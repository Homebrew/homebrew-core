class Suricata < Formula
  desc "Network IDS, IPS, and security monitoring engine"
  homepage "https://suricata.io"
  url "https://www.openinfosecfoundation.org/download/suricata-7.0.1.tar.gz"
  sha256 "6047c75f9e79a9b0cc6d6c7632024a4126812bc212f52acf5d3c813cc7c9fb0b"
  license "GPL-2.0-only"

  livecheck do
    url "https://suricata.io/download/"
    regex(/href=.*?suricata[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "6c0e091bc55413c312adeb12fe40c4f6b6b48ee3cadaf1a26fc9fbb1efd4cdc5"
    sha256 arm64_monterey: "84e3f070aa1c2f353dfa6fa29ce21b015e1bc081bdb7e071b417c8c3db03bd23"
    sha256 arm64_big_sur:  "841856af3e342b605145d8b7aae649c71cf50661d163a5150c422803685b4c43"
    sha256 ventura:        "d7cf0013e35f2bdcd0f65d67649b6b187d2780952a4dc2be6d36ce579e29d0b4"
    sha256 monterey:       "ccf7baf8ffc298dc280d36004437eb6536a7e82a2b0f300fb0b12f82cadd9e93"
    sha256 big_sur:        "5700ef72c2a3c05fb2e345dd75141beb3d4b4976f2672733632f0dad662cba98"
    sha256 x86_64_linux:   "047f924a159c6922ce829f6f4cd18098a083d36d3a59a3feada8cb027cb7b36c"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "libnet"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "python@3.11"
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
