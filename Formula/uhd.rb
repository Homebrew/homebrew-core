class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/v3.13.0.2.tar.gz"
  sha256 "e18d0524cbf571be4847fd7f971dc30c37efd9e7a333761b74e1266a07cbd35b"
  revision 1
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "04491dbf6bbb887e4d65d25e6f02c02ad9c49b210e46a3c4bbaa803c4fd14ceb" => :mojave
    sha256 "de21647f4209a1bbe42c43d9845e7ee7472b9fc41a68ae0bcf108738d2621331" => :high_sierra
    sha256 "832788aca2fa3cb7a58ba44f545977ee2310d27835160913cc44827d599d6d54" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/eb/f3/67579bb486517c0d49547f9697e36582cd19dafb5df9e687ed8e22de57fa/Mako-1.0.7.tar.gz"
    sha256 "4e02fde57bd4abb5ec400181e4c314f56ac3e49ba4fb8b0d50bba18cb27d25ae"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resource("Mako").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    mkdir "host/build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_PYTHON3=ON"
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
