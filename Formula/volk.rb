class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://libvolk.org"
  url "https://github.com/gnuradio/volk.git",
      tag:      "v2.4.1",
      revision: "797b0ac846858d081fbb53ed50e98765ec9cb6b2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 "0324fc38e4ca9a378fa863af8543af8dbfd2eb83a4a22e008f5df434857b655a" => :big_sur
    sha256 "96cdb958c8c97d9ddc96b3aee4aff3101952183c034f9a4d5b750a157756e693" => :catalina
    sha256 "2cc90d04c112cf63c00b8f39c6e3ba297f963b3266ddd144b2924df7519e6e56" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "orc"
  depends_on "python@3.9"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/72/89/402d2b4589e120ca76a6aed8fee906a0f5ae204b50e455edd36eda6e778d/Mako-1.1.3.tar.gz"
    sha256 "8195c8c1400ceb53496064314c6736719c6f25e7479cd24c77be3d9361cddc27"
  end

  def install
    # Set up Mako
    venv_root = libexec/"venv"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", "#{venv_root}/lib/python#{xy}/site-packages"
    venv = virtualenv_create(venv_root, "python3")
    venv.pip_install resource("Mako")

    # Avoid references to the Homebrew shims directory
    inreplace "lib/CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    args = %W[-DPYTHON_EXECUTABLE=#{venv_root}/bin/python -DENABLE_TESTING=OFF]
    system "cmake", ".", *std_cmake_args, *args
    system "make", "install"

    # Set up volk_modtool paths
    site_packages = lib/"python#{xy}/site-packages"
    pth_contents = "import site; site.addsitedir('#{site_packages}')\n"
    (venv_root/"lib/python#{xy}/site-packages/homebrew-volk.pth").write pth_contents
  end

  test do
    system "volk_modtool", "--help"
    system "volk_profile", "--iter", "10"
  end
end
