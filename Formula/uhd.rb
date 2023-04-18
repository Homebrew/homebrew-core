class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.4.0.0",
      revision: "5fac246bc18ab04cb4870026a630e46d0fd87b17"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "d8e5f3f1c35810633487d415c5e1de19558de4131933eeb42e5334e0aaa6a980"
    sha256                               arm64_monterey: "6e4124f87b6091b08f148225c6289d7145f8b17a0c919445886cd3ff9fa1bd9e"
    sha256                               arm64_big_sur:  "a82da41cb44056136c23a6e6f3cb35213bd4877aecc8584f8af8fdf44664f4ec"
    sha256                               ventura:        "63470361e9dc82aa1344e395598367bbc9d217882b1db2be177aacdff65de8f9"
    sha256                               monterey:       "ef8d41ba0e3e67286aaa1d17ae67cbc4c07d264ee14b75bb9760c691f8290ccc"
    sha256                               big_sur:        "ae8b30d5b0112cd4a35e7c05826238e9ec8cecc7665f1d3ab21a6a03647ecabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a898e8cdb49511926e0b3c340ea5b54e66c1c806802f1e586688d244a967ed7"
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
