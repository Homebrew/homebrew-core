class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/refs/tags/v4.9.0.1.tar.gz"
  sha256 "0be26a139f23041c1fb6e9666d84cba839460e3c756057dc48dc067cc356a7bc"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "069d898a967190d493b39b0b70ac3111bdf303389c2475554a8e18367a73b582"
    sha256                               arm64_sequoia: "3e9e65b9f0a9d02033546536b99ca62d5e9cd281982bdfb14979a106f882f029"
    sha256                               arm64_sonoma:  "e1966fd506014c5dc9852cbdb0ed6476fda3f41e02805fa9500e1669fccebf48"
    sha256                               sonoma:        "7efdeef6402f336a0f35e76f838ea4a923928a128e3afe224bd86542e5c96948"
    sha256                               arm64_linux:   "7ce9ee9c5688b6eca8ff1aa4f94f3939b128cd1f16662146c033119a5792122d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18d4a089eb243dd2caa86003ddd2cf79a955209afec4bd1011a5dd21c096114f"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.14"

  on_linux do
    depends_on "ncurses"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/9e/38/bd5b78a920a64d708fe6bc8e0a2c075e1389d53bef8413725c63ba041535/mako-1.3.10.tar.gz"
    sha256 "99579a6f39583fa7e5630a28c3c1f440e4e97a414b80372649c0ce338da2ea28"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  def python3
    "python3.14"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    args = %W[
      -DENABLE_TESTS=OFF
      -DUHD_VERSION=#{version}
    ]
    system "cmake", "-S", "host", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
