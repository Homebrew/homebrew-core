class Suricata < Formula
  include Language::Python::Virtualenv

  desc "Network IDS, IPS, and security monitoring engine"
  homepage "https://suricata.io"
  url "https://www.openinfosecfoundation.org/download/suricata-8.0.4.tar.gz"
  sha256 "81cee7bae69848a9751b2ce0867620eefa52b192e79c20b5eac897600b28b191"
  license "GPL-2.0-only"

  livecheck do
    url "https://suricata.io/download/"
    regex(/href=.*?suricata[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9ff08e23cbe3c78ad7c95098d74221b552b4c498dace04964ff8f9129ecc2c7e"
    sha256 arm64_sequoia: "ec79e69936a64dc39bd1b811e88f1e701b3c68efea72ed8ddc7d49d501e1c2e4"
    sha256 arm64_sonoma:  "be3f13bf99413f8d5be1eedb38b588c95b2c59fd6153ddb68184a59dd23e66ad"
    sha256 sonoma:        "6efb5b963da536e725cc2b8410cf7e425d9f2f4ff3866fa14cca5ae99fd976a1"
    sha256 arm64_linux:   "a112b2142e7a65afec27231ad9361eb0dcd34c73791b015926526b51d06ac0f4"
    sha256 x86_64_linux:  "1970c40449173305f48e525a1c13f0240870ab453958605b07b1abb1a13847f3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "libnet"
  depends_on "libyaml"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "python@3.14"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def python3
    "python3.14"
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
