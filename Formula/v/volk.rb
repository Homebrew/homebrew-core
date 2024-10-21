class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://github.com/gnuradio/volk/releases/download/v3.1.2/volk-3.1.2.tar.gz"
  sha256 "eded90e8a3958ee39376f17c1f9f8d4d6ad73d960b3dd98cee3f7ff9db529205"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 arm64_sequoia: "c7e790569a2a56a6b940629c4a7f43f405e6880dca4ca28fb10c865946a8c082"
    sha256 arm64_sonoma:  "461091295111ed35c5042dc8365ecd5ebb8427f228cf727467e29810e7c30ccf"
    sha256 arm64_ventura: "81d0ba801a5fef0e427d011bcfe612304aced3b066e069cdd1336193f1f97334"
    sha256 sonoma:        "0fa13e15334a491e0a64c9303db8fd497158f2d533b30bdde35d0ff7ed7ae767"
    sha256 ventura:       "b7a3423c4cc84375a4dd2ac5b0694f75b154b4652aebc8bf4373b84b58403bab"
    sha256 x86_64_linux:  "7a3729f082520b38cd8409f2e032c6986d77a056a72f2b152e7e91dfe3309621"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cpu_features"
  depends_on "orc"
  depends_on "python@3.13"

  fails_with gcc: "5" # https://github.com/gnuradio/volk/issues/375

  resource "mako" do
    url "https://files.pythonhosted.org/packages/67/03/fb5ba97ff65ce64f6d35b582aacffc26b693a98053fa831ab43a437cbddb/Mako-1.3.5.tar.gz"
    sha256 "48dbc20568c1d276a2698b36d968fa76161bf127194907ea6fc594fa81f943bc"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b4/d2/38ff920762f2247c3af5cbbbbc40756f575d9692d381d7c520f45deb9b8f/markupsafe-3.0.1.tar.gz"
    sha256 "3e683ee4f5d0fa2dde4db77ed8dd8a876686e3fc417655c2ece9a90576905344"
  end

  def python3
    "python3.13"
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
