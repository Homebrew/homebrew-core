class Uhd < Formula
  desc "Hardware driver for all USRP devices."
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/release_003_010_002_000.tar.gz"
  sha256 "7f96d00ed8a1458b31add31291fae66afc1fed47e1dffd886dffa71a8281fabe"
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "75d23b8007ccc2e092e879368c1cc19fd83622801bf43fd68c37d4947531feaf" => :sierra
    sha256 "74b6bd60d84c0d2af5179df718947b1d56bb955b597efac7a990f0199f5b4114" => :el_capitan
    sha256 "c82e4bc01c14ba4c5490e1af0a83d1137ca71ac2d6dfda4bfff65e34d4aa629b" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "doxygen" => [:build, :optional]
  depends_on "gpsd" => :optional

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/eb/f3/67579bb486517c0d49547f9697e36582cd19dafb5df9e687ed8e22de57fa/Mako-1.0.7.tar.gz"
    sha256 "4e02fde57bd4abb5ec400181e4c314f56ac3e49ba4fb8b0d50bba18cb27d25ae"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resource("Mako").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    mkdir "host/build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_find_devices --help", 1).chomp
  end
end
