class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://github.com/gnuradio/volk.git",
      tag:      "v2.4.1",
      revision: "797b0ac846858d081fbb53ed50e98765ec9cb6b2"
  license "GPL-3.0-or-later"

  revision 1

  bottle do
    sha256 big_sur:  "610c013ef274b1d760bfa8759d6499612e5cd2164ab9fc1afff5d1ea4663b755"
    sha256 catalina: "cfaaedf9ff299ff8d6da4b73b1bdcc842e15c008d087483a38a6fa30529c1356"
    sha256 mojave:   "c517239567cd00327372b732c1fa04300d566eddb13779f9736a6435eee9ec1d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "orc"
  depends_on "python@3.9"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/5c/db/2d2d88b924aa4674a080aae83b59ea19d593250bfe5ed789947c21736785/Mako-1.1.4.tar.gz"
    sha256 "17831f0b7087c313c0ffae2bcbbd3c1d5ba9eeac9c38f2eb7b50e8c99fe9d5ab"
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
