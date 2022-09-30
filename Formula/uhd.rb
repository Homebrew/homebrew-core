class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.3.0.0",
      revision: "1f8fd3457dee48dc472446113a6998c2529adf59"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 1
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "7d33eda257fce9495ff8c86bb277c2c36b30caf18ce7ae95bb7f9acda7895af0"
    sha256                               arm64_big_sur:  "65adf6166d374b0bc8d4e2456776de16e20e661943a00e4862a5ea35d465223e"
    sha256                               monterey:       "3de935aacdace8e219d4c13e71f98da912123599142a0ab9f10e0b7915462d18"
    sha256                               big_sur:        "2b4920306082015e8c671db5850db831719969a9e2a043dfa57b0db1f64e5a47"
    sha256                               catalina:       "fa8008e2a07af9fef475df02730957cc8c2fe64a375ab84a5b539bfb04660fb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a84848784d238c4aa82c0ce082a8e5c1c47542de0829a06c01c2cf9cd66b80be"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.10"

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
    python = "python3.10"
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
