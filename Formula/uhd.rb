class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/v3.11.1.0.tar.gz"
  sha256 "9c6347584e778c5dcdd2dceb296b3e39f3374e38565c1133a88a68a7cac1ec41"
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "27cb9724a9680fb0ff9a1a48d6dcc17ac5e39c7b17bbf67acbf73b318667a30a" => :high_sierra
    sha256 "851eebeaaae5554eccdee403a76a163ecd9793c1f8095ee7105af0e989466219" => :sierra
    sha256 "c9b6d28ef4abf3050fa297b4bc2b56ae9c74d4a4f694dbbf1bb226b82c490cfa" => :el_capitan
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
