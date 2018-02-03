class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/release_003_010_003_000.tar.gz"
  sha256 "3b621f96c4a2257df4444aff597ce16657b65ba4b8f1201e65623ce10bfdace0"
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "09e6e9300165ceb431a585d475584286fd7cb678505f6851bb35c47e4d84ef48" => :high_sierra
    sha256 "c41a4a38499da8686ab1f8f53aad5c0dd83e308ef5a0dd623f26fe2008217754" => :sierra
    sha256 "a74de1f23e1c26c4d490228285878dc436af49dbaf1ff16bc73ae1f5936064cc" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python" if MacOS.version <= :snow_leopard
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
