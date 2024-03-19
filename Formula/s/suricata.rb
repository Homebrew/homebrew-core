class Suricata < Formula
  include Language::Python::Virtualenv

  desc "Network IDS, IPS, and security monitoring engine"
  homepage "https://suricata.io"
  url "https://www.openinfosecfoundation.org/download/suricata-7.0.4.tar.gz"
  sha256 "640060120024be70dbe81f6ec6efc72e46250fcb36219dff67e6417220ff21b7"
  license "GPL-2.0-only"

  livecheck do
    url "https://suricata.io/download/"
    regex(/href=.*?suricata[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "b92e370635c1d3a8c48e573b348f2dd4bf0cbc15657504de3472a6c88f38f718"
    sha256 arm64_ventura:  "91ed3f2dbcf96d42b1f98122c44162f264145b4cdea792981ab31445d99387fa"
    sha256 arm64_monterey: "053d06d86752a15b5c5486fead3310ee858480037aebaf38b554ec1c88d52c61"
    sha256 sonoma:         "4a64a5ddb63ffb45485c4b44c488c80661745d3126d285aa69856fc33c57c6f6"
    sha256 ventura:        "c9d700a49f5b87f12c2aded8cbe181a033340560a90ae95b4a98ee6d7d483263"
    sha256 monterey:       "3f6d96fc5ac79f5a58fd22f11b641b5ebf04b50f172d5f82e1cfe4e4092b8165"
    sha256 x86_64_linux:   "99618885ddae7ed202d22a5b7215789ef2051f756291e393bfcb913843c3e307"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "libnet"
  depends_on "libyaml"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "python@3.12"

  uses_from_macos "libpcap"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
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
