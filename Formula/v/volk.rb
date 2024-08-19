class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://github.com/gnuradio/volk/releases/download/v3.1.2/volk-3.1.2.tar.gz"
  sha256 "eded90e8a3958ee39376f17c1f9f8d4d6ad73d960b3dd98cee3f7ff9db529205"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "3369be458932d78df5c6e4432c9be636096f0b4a798405e77737668cfc7ebce7"
    sha256 arm64_ventura:  "be2ed1dbfd99c846c715a49b552bbfc227e9073c8e3563ac4aece3a729c0e1ac"
    sha256 arm64_monterey: "1e4363cad92930dcd37f4936c9e9a035fe2acc44fb3728351de72944e1bd5b0c"
    sha256 sonoma:         "edf0d750df72c3e36ccdd50cc7ba12e2dfaafd180a042ae1d89909ea9d4dfc76"
    sha256 ventura:        "d5f2a417e4614af7a53a61a195bef94452193e5d0c0181225e6154fc1876bfb6"
    sha256 monterey:       "2deccebd9473a5bc01f398bc1e6cc1da56fafef82a4cbddf06cad03f7c436d7a"
    sha256 x86_64_linux:   "c1395effef2eba67b708e7820e48cd51d25214eded4ce85c77d8c37390244ebe"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cpu_features"
  depends_on "orc"
  depends_on "python@3.12"

  fails_with gcc: "5" # https://github.com/gnuradio/volk/issues/375

  resource "mako" do
    url "https://files.pythonhosted.org/packages/d4/1b/71434d9fa9be1ac1bc6fb5f54b9d41233be2969f16be759766208f49f072/Mako-1.3.2.tar.gz"
    sha256 "2a0c8ad7f6274271b3bb7467dd37cf9cc6dab4bc19cb69a4ef10669402de698e"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  def install
    python3 = "python3.12"

    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", buildpath/"venv"/Language::Python.site_packages(python3)

    # Avoid falling back to bundled cpu_features
    rm_r(buildpath/"cpu_features")

    # Avoid references to the Homebrew shims directory
    inreplace "lib/CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DENABLE_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"volk_modtool", "--help"
    system bin/"volk_profile", "--iter", "10"
  end
end
