class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://github.com/gnuradio/volk/releases/download/v2.5.2/volk-2.5.2.tar.gz"
  sha256 "ead6d39d390a03cec0d65d474b5222654103b304f7f00c730d69ea54a2ca7006"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "8566f1bd591a0c7f03f6de4426f98e0624dced7f094a44feffa6114893548fb0"
    sha256 arm64_big_sur:  "ee952a49b648219774ac7c7a2c331b00c870cb0166b1ec4b8f88013ca7bbae62"
    sha256 monterey:       "71e8168f3f2785af3452e642772cd81f2a42a050e784bf151b42d861405fe796"
    sha256 big_sur:        "82bb5142643c1ab1fba7b2474c15ae9a17eca44fff6687dd95e3a0a6809ff7c5"
    sha256 catalina:       "5c25941d8cedcd1ae612403b9ce1f9f0c8a789002d315a59b905a4718ef8cf56"
    sha256 x86_64_linux:   "c4d82856bd24b3891ba50867f1f384bec6ff625be28114c4e400983d4a5c1d12"
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
