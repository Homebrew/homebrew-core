class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/release_003_010_002_000.tar.gz"
  sha256 "7f96d00ed8a1458b31add31291fae66afc1fed47e1dffd886dffa71a8281fabe"
  revision 2
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "aa08fa06aebb4e3bf05a17d20af2e3cce53e7f31a746a5e89428fd1f0febf83d" => :high_sierra
    sha256 "eaa1134c0ec3f29780e8f391233dc6e147a5fc90848bce46b8f82326fc832728" => :sierra
    sha256 "9896625583be332fe6ba6a8b898d027e8b42e533308eb88e1a361ed48c14120e" => :el_capitan
    sha256 "362332407e28fef3bb1e53b358d1d011d1ef4e9ba81681dd70bef91bba7752b0" => :yosemite
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

  # Fix "error: no member named 'native' in
  # 'boost::asio::basic_datagram_socket<boost::asio::ip::udp>'"
  # Upstream PR from 19 Dec 2017 "Fix build with Boost 1.66"
  patch do
    url "https://github.com/EttusResearch/uhd/pull/148.patch?full_index=1"
    sha256 "f7fcc3091d843f5c85c22845193df1ec75c389b556fd375b5023900908f01b33"
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
