class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  license "LGPL-3.0-or-later"
  revision 3
  compatibility_version 1
  head "https://github.com/gnuradio/volk.git", branch: "main"

  stable do
    url "https://github.com/gnuradio/volk/releases/download/v3.3.0/volk-3.3.0.tar.gz"
    sha256 "89d11c8c8d4213b1b780354cfdbda1fed0c0b65c82847e710638eb3e21418628"

    # Fix compatibility with fmt 12.2+
    patch do
      url "https://github.com/gnuradio/volk/commit/5620097efb4a70620259000d27918dee1d03ee1e.patch?full_index=1"
      sha256 "18e6515ce4932f93bb3e8855c16a411a4de61a6006c7a12d1ac342d5174d08ba"
      type :backport
      resolves "https://github.com/gnuradio/volk/pull/869"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "4c7107f873563792a3331165478d81e21d3eb6959795abb02b1c2100f8e4235f"
    sha256 cellar: :any, arm64_tahoe:       "32f197fc9ed1e52973bc0dd90dc643e84480b7fee8b525d74e04478bf6d9d518"
    sha256 cellar: :any, arm64_sequoia:     "09cc4a97b1af64c4a804b4e40dc0a049d3d622402c925c85bf8f7752646daffb"
    sha256 cellar: :any, arm64_linux:       "1231efc8b87da47a558bae6693aa69a524dc129367935850562063928506eced"
    sha256 cellar: :any, x86_64_linux:      "4b41845d71eab03ba8da3df9822ed08f663c2304113716b2319806697aaba0d2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cpu_features"
  depends_on "fmt"
  depends_on "orc"
  depends_on "python@3.15"

  conflicts_with "vulkan-volk", because: "both install volkConfig.cmake"

  pypi_packages package_name:   "",
                extra_packages: "mako"

  resource "mako" do
    url "https://files.pythonhosted.org/packages/5a/09/e07c4b5579a79f4b16f8d4f29f6c54514ac787c4ad506b8c4f28a0e6b0bf/mako-1.4.3.tar.gz"
    sha256 "cd6537fe88d5fec315c55c2f8529bc4ce7a9a352ad7db3eeaa6a66e2dd4ec37a"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    # Avoid falling back to bundled cpu_features
    rm_r(buildpath/"cpu_features")

    # Avoid references to the Homebrew shims directory
    inreplace "lib/CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{python3}",
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
