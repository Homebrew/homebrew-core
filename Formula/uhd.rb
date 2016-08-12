class Uhd < Formula
  desc "Hardware driver for all USRP devices."
  homepage "http://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/release_003_010_000_000.tar.gz"
  sha256 "9e018c069851fd68ba63908a9f9944763832ce657f5b357d4e6c64293ad0d2cd"
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "e6091ab702424957d1209d1b036714bfe021ad5fc5229213da4d02a573b7af4e" => :el_capitan
    sha256 "6bfebd9fc9da8558e0a617f55dbd7c74e8f75c7fbe995c7e1a77dadf16d3cd40" => :yosemite
    sha256 "8fd41c74a36e3c831da569e04941c961e7c6a8d83a30bd394301315645519a83" => :mavericks
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
