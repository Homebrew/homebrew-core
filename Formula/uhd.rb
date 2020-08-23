class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/v3.15.0.0.tar.gz"
  sha256 "eed4a77d75faafff56be78985950039f8d9d1eb9fcbd58b8862e481dd49825cd"
  revision 1
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "b0988b31234da20fde7aceb5656316fccc3def16516391e5fcb818bd9d9cb563" => :catalina
    sha256 "eff5ec072e00e4ed6b7ccdceda1fdd68a672f8cea36a64046c4e4c348b361146" => :mojave
    sha256 "ded2d939eea70a0ca8e6275552a64fe6a6f9d55cc5b56e6cbed6ceea0394f549" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.8"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/b0/3c/8dcd6883d009f7cae0f3157fb53e9afb05a0d3d33b3db1268ec2e6f4a56b/Mako-1.1.0.tar.gz"
    sha256 "a36919599a9b7dc5d86a7a8988f23a9a3a3d083070023bab23d64f7f1d1e0a4b"
  end

  def install
    # https://github.com/EttusResearch/uhd/issues/313
    inreplace "host/lib/transport/nirio/lvbitx/process-lvbitx.py",
              "autogen_src_path = os.path.relpath(options.output_src_path)",
              "autogen_src_path = os.path.realpath(options.output_src_path)"

    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resource("Mako").stage do
      system Formula["python@3.8"].opt_bin/"python3",
             *Language::Python.setup_install_args(libexec/"vendor")
    end

    mkdir "host/build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_STATIC_LIBS=ON", "-DENABLE_TESTS=OFF"
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
