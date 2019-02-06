class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/v3.13.1.0.tar.gz"
  sha256 "16fb265b9611ff51ea229058824661c04db935cf88fde17af9cb66a8b9299bd5"
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "cdbb577e04715cc175c83397dbb03964870935a97fd4579e1f2a6f9b45a76a0c" => :mojave
    sha256 "71f5cd72db8ecce7c9d7220cf63b92612f43df12dccc4a33d49778cffd295252" => :high_sierra
    sha256 "4503cccbb9709d64efcbc3674c4ae3e777979d56a74d32057c477a569b8271ba" => :sierra
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
