class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/v3.12.0.0.tar.gz"
  sha256 "a4ae40c2e3e6c51941fc59eab2c8131fd03fa837459e287b340c88cf2c9848ed"
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "aebb2cb75a6b9de9d080276184bd1235423b9f7e7d0462cbc5d5baf8173e094c" => :high_sierra
    sha256 "70b3f5d16a9402b58228ee7e63eba9e376ccc8add1ae96cad1525c3072eb6478" => :sierra
    sha256 "f16d9a945cdd6b5797861ae7bc3cae4b819b457b9c32abcf21450b061a1fca04" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@2"
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
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
