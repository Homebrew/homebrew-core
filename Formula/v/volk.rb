class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://github.com/gnuradio/volk/releases/download/v3.0.0/volk-3.0.0.tar.gz"
  sha256 "797c208bd449f77186684c9fa368cc8577fb98ce3763db5de526e6809de32d28"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "c0a5c2ee515d15917cefb2b026ad6839c56beb4662dba097a9516d12d3d900ee"
    sha256 arm64_ventura:  "e16a8fe2ea0edc034efba5d123a5f6ead3ad7e2b1d7073f5bb8ee5b4e3c0b978"
    sha256 arm64_monterey: "feeefe367288110e433ba776918c72c73e50b8b3c6360e7bbb9a476fde417703"
    sha256 sonoma:         "16d5b6931dfb847ff8981acda1dbac48c91f6a528f2fe4fd93070d3bfea1ca43"
    sha256 ventura:        "b9cb846aa9f83f5b9ff363d73ff101f52bb46dc4ab9e4167616e7eb028537eab"
    sha256 monterey:       "88e5cb768c82195b32ad3115b9ba35590aaff351823c713736380cb40f71f788"
    sha256 x86_64_linux:   "a53ab9928c3785f01ce2138c1d534b6478414a8822edbc9323d9294ce83abd18"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "orc"
  depends_on "pygments"
  depends_on "python@3.12"

  on_intel do
    depends_on "cpu_features"
  end

  fails_with gcc: "5" # https://github.com/gnuradio/volk/issues/375

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/05/5f/2ba6e026d33a0e6ddc1dddf9958677f76f5f80c236bd65309d280b166d3e/Mako-1.2.4.tar.gz"
    sha256 "d60a3903dc3bb01a18ad6a89cdbe2e4eadc69c0bc8ef1e3773ba53d44c3f7a34"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  def install
    python = "python3.12"

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
    system "#{bin}/volk_modtool", "--help"
    system "#{bin}/volk_profile", "--iter", "10"
  end
end
