class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://libvolk.org"
  url "https://github.com/gnuradio/volk/releases/download/v2.3.0/volk-2.3.0.tar.xz"
  sha256 "40645886d713ed23295d7fb3e69734b5173a22259886b1a4abdad229a44123b9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 "7b05c83dbd7c17a7cff668ca91e19f12ffe0815a0af792a1da61a4fc0ab5e624" => :catalina
    sha256 "0f3183e0a4852bff180bf659ada1107006a09dea4e5e21c56cfc0cc4db382edb" => :mojave
    sha256 "d8de98a69594e20f41e3ccb0dbd68d1eab7f7c4bcbe71208c7cd770f5b8d5ab8" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "orc"
  depends_on "python@3.8"

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
