class Uhd < Formula
  desc "Hardware driver for all USRP devices."
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/release_003_010_000_000.tar.gz"
  sha256 "9e018c069851fd68ba63908a9f9944763832ce657f5b357d4e6c64293ad0d2cd"
  revision 1

  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "0b9b665bf93de00019350d6205fab14bdd1a9211bb4bbdcb8eacb9ef1378d940" => :sierra
    sha256 "4793081d5e45830e4cbcaa30c1e384263cc51beff1d7a72901314865e16db047" => :el_capitan
    sha256 "83e012c2aa2a7ba34b9b2c870b13c6f08ce923e2c8e56121c8f641c070bc77f7" => :yosemite
  end

  option :universal

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
    args = std_cmake_args

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resource("Mako").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    mkdir "host/build" do
      system "cmake", "..", *args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_find_devices --help", 1).chomp
  end
end
