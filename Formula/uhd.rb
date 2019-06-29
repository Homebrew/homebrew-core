class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/v3.14.1.0.tar.gz"
  sha256 "8fc1ad70d80f7f69a30c957fee218ef8767cfd5a0ee4f0830e506f2b22e5b923"
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "15571aae1178160273c3a308e70cd701ecb7f77ae1ca79a7a54252098979f9c4" => :mojave
    sha256 "4e949556c55a874d52e039ee1bcada2f61482ffc7d99eb17f54b0f1db93d6af2" => :high_sierra
    sha256 "a8201e5fcd76f434863f8b67b8e74e80d4c34db0add402d9d97d3945cbc5af13" => :sierra
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
