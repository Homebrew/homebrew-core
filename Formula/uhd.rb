class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.3.0.0",
      revision: "1f8fd3457dee48dc472446113a6998c2529adf59"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 2
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256                               arm64_ventura:  "203ee442bdb64672f84d66c020a56648e739bf8be379dad9ecac74d67a88e10f"
    sha256                               arm64_monterey: "48ad94802d28473e1e710f1e7dd91b9450cfa2f465e700301626c39a6f5c86a6"
    sha256                               arm64_big_sur:  "b6e76b040b2d1c8274cfaecc16e960057db3c81b4a727291ae4f960b31cee88a"
    sha256                               ventura:        "27fe77514a43d35631aa4b84a34a8026a0421843110445c8c2f0add5237484db"
    sha256                               monterey:       "7a38f27db9c707100eb16b992211ad2debbdbe41f0510c916f9102df7c44feb6"
    sha256                               big_sur:        "dd000e257205cf86cbf42d51109809a06c74489496acc3f741372fd4ea674a4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d216f9ed2caddcc9ca207d395885ee4271106698d62139115b894ebf330827d"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.11"

  fails_with gcc: "5"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/6d/f2/8ad2ec3d531c97c4071572a4104e00095300e278a7449511bee197ca22c9/Mako-1.2.2.tar.gz"
    sha256 "3724869b363ba630a272a5f89f68c070352137b8fd1757650017b7e06fda163f"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
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
