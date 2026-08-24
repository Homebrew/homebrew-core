class Suricata < Formula
  include Language::Python::Virtualenv

  desc "Network IDS, IPS, and security monitoring engine"
  homepage "https://suricata.io"
  url "https://www.openinfosecfoundation.org/download/suricata-8.0.6.tar.gz"
  sha256 "b264584edda4a3b2b462050099c7c54f4f35ac0c7164e41084be9b216c090f8c"
  license "GPL-2.0-only"

  livecheck do
    url "https://suricata.io/download/"
    regex(/href=.*?suricata[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "5467429d1980c9738ad39f3e8a550533169ec7fe6b51ae3a7900c8488ab839c9"
    sha256 arm64_sequoia: "b4b78ac56ea5f6ca45267ce85d14f3e7ac8ea3ba6c4c8f31ee8a910e31f7028f"
    sha256 arm64_sonoma:  "418ab60b075ed7b451e5193aaf24319bf67dbecba4a18b27ce92aeb8f41262e4"
    sha256 sonoma:        "16bf5d573f146d0d588ab9905fd492200a09d4ddd24fd368ee97fb79bb1447a0"
    sha256 arm64_linux:   "1e898b52704f3fa8bd6b3f73b4dde961254dfacfaf7e3089b339754c6966338b"
    sha256 x86_64_linux:  "4038ec5b1a100f989dbda2f26d8cce70a92129a91b7de56ad7a17496b178a8c0"
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

  pypi_packages package_name:   "",
                extra_packages: "pyyaml"

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
      args << "--with-libpcap-includes=#{formula_opt_include("libpcap")}"
      args << "--with-libpcap-libraries=#{formula_opt_lib("libpcap")}"
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
