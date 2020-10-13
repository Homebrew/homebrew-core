class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/v3.15.0.0.tar.gz"
  sha256 "eed4a77d75faafff56be78985950039f8d9d1eb9fcbd58b8862e481dd49825cd"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 1
  head "https://github.com/EttusResearch/uhd.git"

  livecheck do
    url "https://github.com/EttusResearch/uhd/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 "ee9fdf4b27ddf83c6d1965a7bb97b0686518ce67ddf780a2f1713fee9bda9c3a" => :catalina
    sha256 "e3cdd07c0bfa1e29983566cae2fe2b964431f05c4a06479f37e4347d3f1f676b" => :mojave
    sha256 "fbae4fec9ad2802ceab2407915588440dcbdd810d510733064601178b1151f6a" => :high_sierra
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

  # Fix build with Boost 1.73 and later
  # https://github.com/EttusResearch/uhd/issues/347
  # Remove in next version
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b9055b4b/uhd/boost-1.73.diff"
    sha256 "0bf797655424d66f4ceae2feabbd00831bb7b6fa8e3e55e6ed56c7e26dd1a4cd"
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
