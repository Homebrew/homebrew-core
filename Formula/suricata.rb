class Suricata < Formula
  desc "Network IDS, IPS, and security monitoring engine"
  homepage "https://suricata-ids.org/"
  url "https://www.openinfosecfoundation.org/download/suricata-4.0.5.tar.gz"
  sha256 "74dacb4359d57fbd3452e384eeeb1dd77b6ae00f02e9994ad5a7b461d5f4c6c2"
  revision 1

  bottle do
    sha256 "03e7d21ac53d1377f7428adc1f86de957da3c0b5486aa663c71d3f6f7c835296" => :mojave
    sha256 "48a98548def7a0382371d68b032c9d8e462d627b38b8ed2b7df52a1df91cc028" => :high_sierra
    sha256 "99074511a644cfb7688607a9895fc0b431c5f64642566764d5ec911860f8711b" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "libnet"
  depends_on "libyaml"
  depends_on "nspr"
  depends_on "nss"
  depends_on "pcre"
  depends_on "python@2"

  resource "argparse" do
    url "https://files.pythonhosted.org/packages/source/a/argparse/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/source/s/simplejson/simplejson-3.16.0.tar.gz"
    sha256 "b1f329139ba647a9548aa05fb95d046b4a677643070dc2afc05fa2e975d09ca5"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    jansson = Formula["jansson"]
    libnet = Formula["libnet"]
    libmagic = Formula["libmagic"]

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
      --with-libnet-libs=#{libnet.opt_lib}
    ]

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
