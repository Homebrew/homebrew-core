class Suricata < Formula
  desc "Network IDS, IPS, and security monitoring engine"
  homepage "https://suricata.io"
  url "https://www.openinfosecfoundation.org/download/suricata-6.0.7.tar.gz"
  sha256 "d172289358e22d57e85b3f28f4a49f9f7844d99e1b4b4680510fe81fb9b16446"
  license "GPL-2.0-only"

  livecheck do
    url "https://suricata.io/download/"
    regex(/href=.*?suricata[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "ec11a1ef5b343cfe7f98771cf48577c35ec5bb5e8c28d4df7b9cfb6342b408a3"
    sha256 arm64_big_sur:  "df690a5e1088ba557985523a073cb8e16ec7a84d521cb55d650b13f162788f8d"
    sha256 monterey:       "e0e5d11da8107983db6b260544993a888b6310d23361c1cf4975f4c2c74b8835"
    sha256 big_sur:        "c117b6382dea25ec3f1e4c6bd99993e6051ce7fc48c2913e2f452179f114ead3"
    sha256 catalina:       "86b7b745349c12e0e412c6de8a1492e7a1d931f1b56fd6b8fe5f82f98753cc92"
    sha256 x86_64_linux:   "307db428a2a7734ad86f6496dfa230829849b17569316ca8a12a7f63ebdb46ae"
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
  depends_on "python@3.10"
  depends_on "pyyaml"

  uses_from_macos "libpcap"

  resource "argparse" do
    url "https://files.pythonhosted.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/7a/47/c7cc3d4ed15f09917838a2fb4e1759eafb6d2f37ebf7043af984d8b36cf7/simplejson-3.17.6.tar.gz"
    sha256 "cf98038d2abf63a1ada5730e91e84c642ba6c225b0198c3684151b1f80c5f8a6"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    directory "libhtp"
  end

  def install
    python = "python3.10"

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor"/Language::Python.site_packages(python)
    resources.each do |r|
      r.stage do
        system python, *Language::Python.setup_install_args(libexec/"vendor", python)
      end
    end

    jansson = Formula["jansson"]
    libmagic = Formula["libmagic"]
    libnet = Formula["libnet"]

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
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

    system "./configure", *args
    # setuptools>=60 prefers its own bundled distutils, which breaks the installation
    # pkg_resources.DistributionNotFound: The 'suricata-update==1.2.3' distribution was not found
    # Remove when deprecated distutils installation is no longer used
    with_env(SETUPTOOLS_USE_DISTUTILS: "stdlib") do
      system "make", "install-full"
    end

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])

    # Leave the magic-file: prefix in otherwise it overrides a commented out line rather than intended line.
    inreplace etc/"suricata/suricata.yaml", %r{magic-file: /.+/magic}, "magic-file: #{libmagic.opt_share}/misc/magic"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/suricata --build-info")
  end
end
