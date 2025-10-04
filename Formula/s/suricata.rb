class Suricata < Formula
  include Language::Python::Virtualenv

  desc "Network IDS, IPS, and security monitoring engine"
  homepage "https://suricata.io"
  url "https://www.openinfosecfoundation.org/download/suricata-8.0.1.tar.gz"
  sha256 "bd868f41717e5431cdda3a99386810257aafdbe2dbcbb58d07fb8476a03358a5"
  license "GPL-2.0-only"

  livecheck do
    url "https://suricata.io/download/"
    regex(/href=.*?suricata[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b3a196d85bd926566c6cfe7e02025d7945f8e3b5adedf7a94add7baf176b2164"
    sha256 arm64_sequoia: "be02fc4c799a4b4071a88c6bde2468b38ba6422345aa1b917a4ee5c41e8745c2"
    sha256 arm64_sonoma:  "7a8c8fc1c63b9772a45034931bbdbdcafb7fedb5add6f4af62f9cdb0c3033309"
    sha256 sonoma:        "b3f28b8f229a545ac5b53f6810c9ce6c76988bf71962ffb8803f2925a71761cd"
    sha256 arm64_linux:   "8505ae87ec61c010f5cc69ef4f174d4817953646c49b6ba5f4c82f6db62dbc87"
    sha256 x86_64_linux:  "b14e8bdae8de848e0c3a4423e3f51e1cd03bba3ddb58327371a2e84ed7fb41ce"
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
