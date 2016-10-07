class Uhd < Formula
  desc "Hardware driver for all USRP devices."
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/release_003_010_000_000.tar.gz"
  sha256 "9e018c069851fd68ba63908a9f9944763832ce657f5b357d4e6c64293ad0d2cd"
  revision 1

  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "df0ce6e9484685be20eb016aa2b02974f7ba101f9c4a409b75902eb044a6e118" => :sierra
    sha256 "73fd0a522d1e20635dcae8beaa565ff07f441ae1cb4ed7af9a1311ad224ece7c" => :el_capitan
    sha256 "2a0a5b94a8f3c70cecfa7952855431eba304ed9509beeba5d9c892465d69d990" => :yosemite
    sha256 "144dac9e3208b80681b6c40dc981bf28cc5938ebd4e52471f608b4a0fc1eb43b" => :mavericks
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
