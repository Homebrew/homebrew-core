class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/v3.13.0.1.tar.gz"
  sha256 "ee5475e7ffbb14441b323cc2fc73950cde2326fd00772dab62efa677f27a97bf"
  revision 2
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    rebuild 1
    sha256 "91caa706bb5a1b05e28b65c76dce4510d55e41dcc401a56f91821729e911ea8a" => :mojave
    sha256 "2a8b15cc1c65ec951f7da9afea0eb716b126d40681cc490ace03c8ab2b25add2" => :high_sierra
    sha256 "cd1b2a157c4f822be838eae6d047308f7907abac9b72726f9b2ef0dfce06483e" => :sierra
    sha256 "2593c3ebd3901a0d146286b20f8c43207e8a309beca5f7a926af9032ac17ea51" => :el_capitan
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
