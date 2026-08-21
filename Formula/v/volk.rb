class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  license "LGPL-3.0-or-later"
  revision 2
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
    sha256 cellar: :any, arm64_tahoe:   "191cd1de815b6a227597a8d734e323a9d8f41587da9e2ef0f6f8be98c716bf6c"
    sha256 cellar: :any, arm64_sequoia: "f62aa1a95e3f8ed22968fe8e92b036754db1c02f9d80f6ed0cccbbfd7dfc5f2f"
    sha256 cellar: :any, arm64_sonoma:  "3454fbda5eae8449ce41463f6f88c929cdb054aa2feb024d8a2be58770aeacbc"
    sha256 cellar: :any, sonoma:        "2d359de9c959e7ef49d200f8f702158845d2730213a4f5b73de126b4a93f7897"
    sha256 cellar: :any, arm64_linux:   "6fb7686968e2c94fee1d4a4829a8a89430ebb96eb7f522c935cafae913cf13a0"
    sha256 cellar: :any, x86_64_linux:  "303e1b62238f08c8929062431295a62c915fd5191e4f3c543390d73e14ff4ce8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cpu_features"
  depends_on "fmt"
  depends_on "orc"
  depends_on "python@3.14"

  conflicts_with "vulkan-volk", because: "both install volkConfig.cmake"

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

  def install
    python3 = "python3.14"
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
