class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.4.0.0",
      revision: "5fac246bc18ab04cb4870026a630e46d0fd87b17"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 2
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "8250ca9794faec99b650897251248edac8b870e3ef2e4cc0d6483395dfac31a1"
    sha256                               arm64_monterey: "e9872b1503b080ec7459da4dba0a82b0c496052cd1b27f276d367e8fe950f2e9"
    sha256                               arm64_big_sur:  "b1408a73f1a9f0fbc0f0c08fa3f81f52c2b9170827ae37c831a4db3b52219c90"
    sha256                               ventura:        "792a022d2a71e3a3006cf838d96c9acb613084be4cf287105908d7cb895602d0"
    sha256                               monterey:       "e335eceed365a6a9f1f7455adfdcef9555294ffcfcf60d27e987b86542996055"
    sha256                               big_sur:        "be9bc381389235fdf3f149f3469fd7aad21ba3b9930917c43f8587d79fa96e03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dadff33b5a4094cdc5629bc4330918c387798434d4ff6b744241dfc5c721572d"
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

  # See https://github.com/EttusResearch/uhd/commit/c385d20eeea717b3859ac6a2bcc247b69fc66003
  # The above is not yet reflected in 4.4.0.0.
  patch do
    url "https://github.com/EttusResearch/uhd/commit/c385d20eeea717b3859ac6a2bcc247b69fc66003.patch?full_index=1"
    sha256 "57d86301e0bb1562cd03cdd51fea891629278a6304326bea9843ac32d46a7e63"
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
