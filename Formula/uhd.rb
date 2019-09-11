class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/v3.14.1.0.tar.gz"
  sha256 "8fc1ad70d80f7f69a30c957fee218ef8767cfd5a0ee4f0830e506f2b22e5b923"
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    rebuild 1
    sha256 "e863c8d13b724e3173450439dfe83c4445494bd2273ae805ca358f8a28836082" => :mojave
    sha256 "a3936c62d3b079197e9f3cbf12cf6fb7aeeaacc99e477424f541462a06830921" => :high_sierra
    sha256 "aa90d30bc003ef14116d2aed08ea159276ad0bb414e553eca95d7f86e8dd072d" => :sierra
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
      system "cmake", "..", *std_cmake_args, "-DENABLE_PYTHON3=ON", "-DENABLE_STATIC_LIBS=ON"
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
