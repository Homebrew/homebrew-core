class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://github.com/gnuradio/volk/releases/download/v2.5.2/volk-2.5.2.tar.gz"
  sha256 "ead6d39d390a03cec0d65d474b5222654103b304f7f00c730d69ea54a2ca7006"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "da9599f4d5011bd2b77442d72e2310114da8333bb50199ba6cb250ff4004c0b7"
    sha256 arm64_big_sur:  "aaa8e8718a34c2c0f63fae59451f819ed2b05fd236c6030a3ee9ea097d92eaad"
    sha256 monterey:       "7bc78a7916cca7a07c8465566a7d44d5e6d6ba2d458e6f93939960c0ea1c8846"
    sha256 big_sur:        "216eaf5b947e2c67bd35ad5775cc6b62c917937829e76d76234d7ae986f59748"
    sha256 catalina:       "dcb073b744df9431a99d0ef1c9fa3662d9788497b9253a2c11433e75af61a14c"
    sha256 x86_64_linux:   "67a28b60dce85baaac4a4d750fda3ae329918ee65e2f9f6086d891648bef050d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "orc"
  depends_on "python@3.10"

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

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
  end

  def install
    python = "python3.10"

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
