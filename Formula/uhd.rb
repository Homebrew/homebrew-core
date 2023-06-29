class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.4.0.0",
      revision: "5fac246bc18ab04cb4870026a630e46d0fd87b17"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 1
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "5192c19ef635a0162939c1081446f5cb8cf2dd5a92c3a17b37f8e6945a7964ed"
    sha256                               arm64_monterey: "2b800f76d257b08949c424c94c12925e78b536c0420ddfe88c4adbe8c21855f9"
    sha256                               arm64_big_sur:  "f6773619a414a4fa6eda95b805f506d2aaa0f51a64fb01eedb69cf1a68e112ca"
    sha256                               ventura:        "0f660fd7eaeb50c7a3ec89babf697aa7eefe53955a2a11324371251cd61c18ea"
    sha256                               monterey:       "528a304d4c87793738ead29c11f2ef9eff3138c6883cc5362cd95777234b8199"
    sha256                               big_sur:        "41e8dbeca5aeef65b5de9d94f80ef66e71b5a6cbdae312222294716d64d302fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "031608eb36683bd8dca86b7e6e58e7a6baaaa63df99f48a8205165695f745a74"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.11"

  fails_with gcc: "5"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/05/5f/2ba6e026d33a0e6ddc1dddf9958677f76f5f80c236bd65309d280b166d3e/Mako-1.2.4.tar.gz"
    sha256 "d60a3903dc3bb01a18ad6a89cdbe2e4eadc69c0bc8ef1e3773ba53d44c3f7a34"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  def install
    python = "python3.11"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor"/Language::Python.site_packages(python)

    resources.each do |r|
      r.stage do
        system python, *Language::Python.setup_install_args(libexec/"vendor", python)
      end
    end

    system "cmake", "-S", "host", "-B", "host/build", "-DENABLE_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "host/build"
    system "cmake", "--install", "host/build"
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
