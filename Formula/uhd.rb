class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/v3.14.1.0.tar.gz"
  sha256 "8fc1ad70d80f7f69a30c957fee218ef8767cfd5a0ee4f0830e506f2b22e5b923"
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "fd131dbc43c309c4f1ec23c6c7940c31eb60f0e6ff05d1a0ad65aa03d0630ce3" => :mojave
    sha256 "0aa1e0de9fbff3ed4068342542e49e90c5d5ed85107d67235a8c083c645ddb6a" => :high_sierra
    sha256 "449cf96866e67ec63207dbcc4d67d2d5b87282511ceada9a2fcb22974d512908" => :sierra
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
