class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://github.com/gnuradio/volk/releases/download/v3.3.0/volk-3.3.0.tar.gz"
  sha256 "89d11c8c8d4213b1b780354cfdbda1fed0c0b65c82847e710638eb3e21418628"
  license "LGPL-3.0-or-later"
  revision 2
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d1dc8f56e9a0be8b1015b455632f1a769d8e846648cfe48ed8ed137d393792a1"
    sha256 cellar: :any,                 arm64_sequoia: "3837e14ee29c45da87e3ecf1723bf711d7ca623b1a5dadad4bcf770fbda3f2e0"
    sha256 cellar: :any,                 arm64_sonoma:  "ab0a316c081d3d9c55e4a4945b14d785a08a0fcd3eec169ec1f372f69d90d9cf"
    sha256 cellar: :any,                 sonoma:        "b532a76c0551cd453561d50b7d84e0d7bb69c3108e87db8682da04b1b98948e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27583f1b7bf10ed3f88fac9e12df7952418586c89eb127ead86612785da529c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b50c782d3b4b28e70aeebf0f8c1aa6b61e20c7362cd95008f00b9186d7bc369f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cpu_features"
  depends_on "fmt"
  depends_on "orc"
  depends_on "python@3.14"

  pypi_packages package_name:   "",
                extra_packages: "mako"

  resource "mako" do
    url "https://files.pythonhosted.org/packages/00/62/791b31e69ae182791ec67f04850f2f062716bbd205483d63a215f3e062d3/mako-1.3.12.tar.gz"
    sha256 "9f778e93289bd410bb35daadeb4fc66d95a746f0b75777b942088b7fd7af550a"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  def python3
    "python3.14"
  end

  def install
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
