class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/v3.11.0.1.tar.gz"
  sha256 "b8b0aa9ca347353333c2d6f52193a01b6c7dbcdaf5e21250c00210d3f8b0fabd"
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "a4cf0865b69f80ad014e7105e81dd291ed4857c87f71a90185c1139a862f759a" => :high_sierra
    sha256 "2836e02d62f684445fd2f73d55f22dd335e7b9418f6451f5998df10faea19a1c" => :sierra
    sha256 "14ae2013ac52c4614b3d22c3dc00c34e7ba45816be7c2c932d624fc91a20b5bb" => :el_capitan
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
