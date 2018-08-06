class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/v3.13.0.1.tar.gz"
  sha256 "ee5475e7ffbb14441b323cc2fc73950cde2326fd00772dab62efa677f27a97bf"
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "88c7c8ba71ef237682afef3d2397ccd84623ad38e9ce256e8f45114122a0ffc0" => :high_sierra
    sha256 "9683435c6f7275add84bd725b7753052e34e4f6031b898822a8395113f787117" => :sierra
    sha256 "36cdebae5a9f4ff7615f26440d3baab7aa604914e1bcc3f095f6f1dba96b75e7" => :el_capitan
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
