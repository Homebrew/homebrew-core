class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/v3.13.0.2.tar.gz"
  sha256 "e18d0524cbf571be4847fd7f971dc30c37efd9e7a333761b74e1266a07cbd35b"
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "e19d53e9ed42c451958e696c15f0f2ab96e4d9c8ea308db31ab389447de21752" => :mojave
    sha256 "48ee7b1d938d8506bff99c2186df4e34bc294d0e99d5f1996adbb427973fa15b" => :high_sierra
    sha256 "b968c2eaf1d5b7891ed7d4ed83d63acd656afadf96608288b88d9d96c345e04c" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@2"

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
