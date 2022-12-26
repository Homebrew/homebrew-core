class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://github.com/gnuradio/volk/releases/download/v2.5.2/volk-2.5.2.tar.gz"
  sha256 "ead6d39d390a03cec0d65d474b5222654103b304f7f00c730d69ea54a2ca7006"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 arm64_ventura:  "5e9d7d3ad47fd6aa48f00671aa60a533dc6fc956c24f3c15890d1c45d84270df"
    sha256 arm64_monterey: "9bf109cded4de487f53c6cbb51c33c85ed15d8b4361a7c5d43f9f4c5bdbe683e"
    sha256 arm64_big_sur:  "68cd76a336bb15bc607f66c4af0bd73d700ddc7ae831fb90f137c15532b65a05"
    sha256 ventura:        "24361c7fef223c44a047625469ea932b69468a677bfaae8c59a59084f5a89b72"
    sha256 monterey:       "e7580fa2cbb6de6837df1361ccfb403fa3106a009ac8bd2e08a02eb7a10ea12a"
    sha256 big_sur:        "541026b784ba6ed5e0067088330eb7226dab2b6a97e259841321938f0aa8843d"
    sha256 catalina:       "332e9cfa3b5b8d1a812aa32da50a51acdd1af5b884901f3de7e3f89a917e75fb"
    sha256 x86_64_linux:   "84df5dd567f628ac17713aefbb1a40c1e5795801d6baa7d159ad4aaef820bc10"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "orc"
  depends_on "pygments"
  depends_on "python@3.11"

  on_intel do
    depends_on "cpu_features"
  end

  fails_with gcc: "5" # https://github.com/gnuradio/volk/issues/375

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

    # Set up Mako
    venv_root = libexec/"venv"
    ENV.prepend_create_path "PYTHONPATH", venv_root/Language::Python.site_packages(python)
    venv = virtualenv_create(venv_root, python)
    venv.pip_install resources

    # Avoid references to the Homebrew shims directory
    inreplace "lib/CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    # cpu_features fails to build on ARM macOS.
    args = %W[
      -DPYTHON_EXECUTABLE=#{venv_root}/bin/python
      -DENABLE_TESTING=OFF
      -DVOLK_CPU_FEATURES=#{Hardware::CPU.intel?}
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Set up volk_modtool paths
    site_packages = prefix/Language::Python.site_packages(python)
    pth_contents = "import site; site.addsitedir('#{site_packages}')\n"
    (venv_root/Language::Python.site_packages(python)/"homebrew-volk.pth").write pth_contents
  end

  test do
    system "volk_modtool", "--help"
    system "volk_profile", "--iter", "10"
  end
end
