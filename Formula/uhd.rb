class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/v3.15.0.0.tar.gz"
  sha256 "eed4a77d75faafff56be78985950039f8d9d1eb9fcbd58b8862e481dd49825cd"
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
    url "https://files.pythonhosted.org/packages/b0/3c/8dcd6883d009f7cae0f3157fb53e9afb05a0d3d33b3db1268ec2e6f4a56b/Mako-1.1.0.tar.gz"
    sha256 "a36919599a9b7dc5d86a7a8988f23a9a3a3d083070023bab23d64f7f1d1e0a4b"
  end

  def install
    # https://github.com/EttusResearch/uhd/issues/313
    inreplace "host/lib/transport/nirio/lvbitx/process-lvbitx.py",
              "autogen_src_path = os.path.relpath(options.output_src_path)",
              "autogen_src_path = os.path.realpath(options.output_src_path)"

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resource("Mako").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    mkdir "host/build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_STATIC_LIBS=ON", "-DENABLE_TESTS=OFF"
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
