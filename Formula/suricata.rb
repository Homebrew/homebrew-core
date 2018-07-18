class Suricata < Formula
  desc "Network IDS, IPS, and security monitoring engine"
  homepage "https://suricata-ids.org/"
  url "https://www.openinfosecfoundation.org/download/suricata-4.0.5.tar.gz"
  sha256 "74dacb4359d57fbd3452e384eeeb1dd77b6ae00f02e9994ad5a7b461d5f4c6c2"

  bottle do
    sha256 "d01576e7a951c8909a2193e758ca7d19b5d47d818547172317d4e47a63b08245" => :high_sierra
    sha256 "45581acbe7020a50fea0dc1fb72a71739053b1ad12f493f10b20b2a910809c9f" => :sierra
    sha256 "76b6f1235a829f6744181f82ed216a31060b1e266cbdb519d78629416b46b18a" => :el_capitan
  end

  depends_on "python@2"
  depends_on "pkg-config" => :build
  depends_on "libmagic"
  depends_on "libnet"
  depends_on "libyaml"
  depends_on "pcre"
  depends_on "nss"
  depends_on "nspr"
  depends_on "geoip" => :optional
  depends_on "lua" => :optional
  depends_on "luajit" => :optional
  depends_on "jansson" => :optional
  depends_on "hiredis" => :optional

  resource "argparse" do
    url "https://files.pythonhosted.org/packages/source/a/argparse/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/source/s/simplejson/simplejson-3.16.0.tar.gz"
    sha256 "b1f329139ba647a9548aa05fb95d046b4a677643070dc2afc05fa2e975d09ca5"
  end

  def install
    libnet = Formula["libnet"]
    libmagic = Formula["libmagic"]

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-libnet-includes=#{libnet.opt_include}
      --with-libnet-libs=#{libnet.opt_lib}
      --with-libmagic-includes=#{libmagic.opt_include}
      --with-libmagic-libraries=#{libmagic.opt_lib}
    ]

    args << "--enable-lua" if build.with? "lua"
    args << "--enable-luajit" if build.with? "luajit"

    if build.with? "geoip"
      geoip = Formula["geoip"]
      args << "--enable-geoip"
      args << "--with-libgeoip-includes=#{geoip.opt_include}"
      args << "--with-libgeoip-libs=#{geoip.opt_lib}"
    end

    if build.with? "jansson"
      jansson = Formula["jansson"]
      args << "--with-libjansson-includes=#{jansson.opt_include}"
      args << "--with-libjansson-libraries=#{jansson.opt_lib}"
    end

    if build.with? "hiredis"
      hiredis = Formula["hiredis"]
      args << "--enable-hiredis"
      args << "--with-libhiredis-includes=#{hiredis.opt_include}"
      args << "--with-libhiredis-libraries=#{hiredis.opt_lib}"
    end
    system "./configure", *args
    system "make", "install-full"

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    # Leave the magic-file: prefix in otherwise it overrides a commented out line rather than intended line.
    inreplace etc/"suricata/suricata.yaml", %r{magic-file: /.+/magic}, "magic-file: #{libmagic.opt_share}/misc/magic"
  end

  test do
    assert_match(/#{version}/, shell_output("#{bin}/suricata --build-info"))
  end
end
