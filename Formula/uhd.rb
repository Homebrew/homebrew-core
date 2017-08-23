class Uhd < Formula
  desc "Hardware driver for all USRP devices."
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/release_003_010_000_000.tar.gz"
  sha256 "9e018c069851fd68ba63908a9f9944763832ce657f5b357d4e6c64293ad0d2cd"
  revision 4
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
    url "https://files.pythonhosted.org/packages/7a/ae/925434246ee90b42e8ef57d3b30a0ab7caf9a2de3e449b876c56dcb48155/Mako-1.0.4.tar.gz"
    sha256 "fed99dbe4d0ddb27a33ee4910d8708aca9ef1fe854e668387a9ab9a90cbf9059"
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
