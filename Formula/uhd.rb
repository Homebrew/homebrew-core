class Uhd < Formula
  desc "Hardware driver for all USRP devices."
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/release_003_010_002_000.tar.gz"
  sha256 "7f96d00ed8a1458b31add31291fae66afc1fed47e1dffd886dffa71a8281fabe"
  revision 1
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "967410dd6dbef3dbf11fb9e67913e0b27db7826ae5e632febba4afd4b70de95a" => :sierra
    sha256 "cd725da48a358e4633b168a1dee335263cd50f5bb7ad846c40cf2688146a5d2e" => :el_capitan
    sha256 "e064ca92e9e3d2964a6d86141c95e981612a8938d5ee5ea4e39c84e3b1a5015a" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on :python if MacOS.version <= :snow_leopard
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
    assert_match version.to_s, shell_output("#{bin}/uhd_find_devices --help", 1).chomp
  end
end
