class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://github.com/gnuradio/volk/releases/download/v2.5.1/volk-2.5.1.tar.gz"
  sha256 "8f7f2f8918c6ba63ebe8375fe87add347046b8b3acbba2fb582577bebd8852df"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_monterey: "ae6e2c945311f017392c7548c324be5125961871f3cb45a4a35e35691bc71452"
    sha256 arm64_big_sur:  "092d71d862d5ea0e280ed4054b5518bb9dc3abe811b9fdb761c963415c1a58a3"
    sha256 monterey:       "dbe656e0a904327315768de793ad217e037aca3c923a30690bc60a397b995aa9"
    sha256 big_sur:        "07e1f824ce18879911add5bf1daa7ad56a46acb287d537bffda7e0f2124887ae"
    sha256 catalina:       "1af0e5dfda38f5e784aec81108adde59be60c681c95c5ebba467ea5d08d70b6c"
    sha256 x86_64_linux:   "5258900d6945fbad99afd6d4382ecead141bcd728b32a5fc6521dfffa974131e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "orc"
  depends_on "python@3.10"

  on_linux do
    depends_on "gcc"
  end

  on_intel do
    depends_on "cpu_features"
  end

  fails_with gcc: "5" # https://github.com/gnuradio/volk/issues/375

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/af/b6/42cd322ae555aa770d49e31b8c5c28a243ba1bbb57ad927e1a5f5b064811/Mako-1.1.6.tar.gz"
    sha256 "4e9e345a41924a954251b95b4b28e14a301145b544901332e658907a7464b6b2"
  end

  def install
    python = "python3.10"

    # Set up Mako
    venv_root = libexec/"venv"
    ENV.prepend_create_path "PYTHONPATH", venv_root/Language::Python.site_packages(python)
    venv = virtualenv_create(venv_root, python)
    venv.pip_install resource("Mako")

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
