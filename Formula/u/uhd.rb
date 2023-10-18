class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.5.0.0",
      revision: "471af98f6b595f5fd52d62303287d968ed2a8d0b"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "82c406117d62200358523c86d9dd3b30eb85e0f87836c7b57641d957a2ebb6bc"
    sha256                               arm64_ventura:  "9dc6ed062449ec39e8c882c3332169c512e156f175919bae3ce4a2702c668cfe"
    sha256                               arm64_monterey: "81f0e5e1b3d9f4251466897ecc3c5ddc12cf0dbdcb25cf13cbac51cbb5256a96"
    sha256                               arm64_big_sur:  "ec241eed9ad2249695a364bb796741ace35f2259f3ce2c3cda0607d5918c7eec"
    sha256                               sonoma:         "85726fa8481311ed9ec903b91d246bf0cdcef1d7cadb5ffc8569ffdbc6296e92"
    sha256                               ventura:        "1190bd80ef912e96adf96bdf67bbbfb7e74bf310cb4c5b2986e0f24c484e30d2"
    sha256                               monterey:       "019f803d3c7826cf510217b97c35765fe16f1ddae043f44478cddb2926c0b01f"
    sha256                               big_sur:        "e596da5bb83ecb3449e8aba4c04026caa16592ccbf4e330c9a4d74d0ba7a83bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cf89006de8952c7347e8dd9d1adbebf4b379465bce3eca853d419d9e85a9a4e"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python-markupsafe"
  depends_on "python@3.11"

  fails_with gcc: "5"

  resource "mako" do
    url "https://files.pythonhosted.org/packages/05/5f/2ba6e026d33a0e6ddc1dddf9958677f76f5f80c236bd65309d280b166d3e/Mako-1.2.4.tar.gz"
    sha256 "d60a3903dc3bb01a18ad6a89cdbe2e4eadc69c0bc8ef1e3773ba53d44c3f7a34"
  end

  def python3
    "python3.11"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor"/Language::Python.site_packages(python3)

    resource("mako").stage do
      system python3, *Language::Python.setup_install_args(libexec/"vendor", python3)
    end

    system "cmake", "-S", "host", "-B", "host/build", "-DENABLE_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "host/build"
    system "cmake", "--install", "host/build"
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
