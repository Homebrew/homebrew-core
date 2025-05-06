class Suricata < Formula
  include Language::Python::Virtualenv

  desc "Network IDS, IPS, and security monitoring engine"
  homepage "https://suricata.io"
  url "https://www.openinfosecfoundation.org/download/suricata-7.0.10.tar.gz"
  sha256 "197f925ea701bdcb4a15aca024b06546b002674cd958b58958f29a5bb214d759"
  license "GPL-2.0-only"

  livecheck do
    url "https://suricata.io/download/"
    regex(/href=.*?suricata[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "5e50075c07a38113f0905b09949d8edaf7b69f43348a9f90bbf906628b176ca7"
    sha256 arm64_sonoma:  "d38da4f84e736c682dcc662bf774a9552680f51a4d0a8b2f28c185a9634d1a10"
    sha256 arm64_ventura: "36156e9cff89c5efd7a27fa77527cb5e5a5ab61e85efa951cf8b5c6d1745a5d6"
    sha256 sonoma:        "efd4d6e8ecf31f3f712b42803954c96c1cf04cd2b24ed383982d99bffda93b9c"
    sha256 ventura:       "a14897dd0012afe2d61cee29e8cc672b93955151a727e8110fe21a90700c5d2f"
    sha256 arm64_linux:   "6d14fa596b9c558e0b1234f3d17bbd4412d1390d7259f9802a50ff58a83e0719"
    sha256 x86_64_linux:  "1bd7152a8f5ca94dbbc625a9417dd3c56c2370a13843e3050d58b561d705016b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "libnet"
  depends_on "libyaml"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "python@3.13"

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def python3
    "python3.13"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"

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

    system "./configure", *args, *std_configure_args
    system "make", "install-full"

    # Leave the magic-file: prefix in otherwise it overrides a commented out line rather than intended line.
    inreplace etc/"suricata/suricata.yaml", %r{magic-file: /.+/magic}, "magic-file: #{libmagic.opt_share}/misc/magic"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/suricata --build-info")
    assert_match "Found Suricata", shell_output("#{bin}/suricata-update list-sources")
  end
end
