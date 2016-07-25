class Uhd < Formula
  desc "Hardware driver for all USRP devices."
  homepage "http://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/release_003_009_004.tar.gz"
  sha256 "84de6e0033b9a5848d6fd7ba7050ba18fb7145c284d1d15e1207b2d9196d7f9e"
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "4180285a8cb02173674101cb62f44fe455d722109a96e88e58774a5156df7bfe" => :el_capitan
    sha256 "1e928392be8f8307b181868a33de3c26c7f6d4487c1204391ffe8f35202dabfe" => :yosemite
    sha256 "22ac44432b35a7a165d66a34f003c026607a086a770e14a30b2b77d2b898d613" => :mavericks
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "doxygen" => [:build, :optional]
  depends_on "gpsd" => :optional

  resource "Mako" do
    url "https://pypi.python.org/packages/source/M/Mako/Mako-1.0.2.tar.gz"
    sha256 "2550c2e4528820db68cbcbe668add5c71ab7fa332b7eada7919044bf8697679e"
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
