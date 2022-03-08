class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://github.com/gnuradio/volk/releases/download/v2.5.1/volk-2.5.1.tar.gz"
  sha256 "8f7f2f8918c6ba63ebe8375fe87add347046b8b3acbba2fb582577bebd8852df"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_monterey: "70fd5051aedcc1d69d4f8753cce4e4f3d525941c3ed585afc489dc917278d6e8"
    sha256 arm64_big_sur:  "547404790c044f95094495013e08be847a9391c0aa0f83edd00f6b1d641d08d4"
    sha256 monterey:       "7a5649c751b5d0eb132f56dc0e824c8777f5a4a52817db8d669ee172444c1bd3"
    sha256 big_sur:        "b2b1e6881db8b03120589969f93c94de26b7fa61442fe6823401c0d3c86a84ef"
    sha256 catalina:       "a872a8cfae761d6667225a9b69acc0856ca8663942f06df654f997f2a045f286"
    sha256 x86_64_linux:   "5d978d61f37c0a0266f0f72197ade95efa8c87ddcbed36cf6611c06b921f2676"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cpu_features" if Hardware::CPU.intel?
  depends_on "orc"
  depends_on "python@3.9"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # https://github.com/gnuradio/volk/issues/375

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/af/b6/42cd322ae555aa770d49e31b8c5c28a243ba1bbb57ad927e1a5f5b064811/Mako-1.1.6.tar.gz"
    sha256 "4e9e345a41924a954251b95b4b28e14a301145b544901332e658907a7464b6b2"
  end

  def install
    # Set up Mako
    venv_root = libexec/"venv"
    ENV.prepend_create_path "PYTHONPATH", venv_root/Language::Python.site_packages("python3")
    venv = virtualenv_create(venv_root, "python3")
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
    site_packages = prefix/Language::Python.site_packages("python3")
    pth_contents = "import site; site.addsitedir('#{site_packages}')\n"
    (venv_root/Language::Python.site_packages("python3")/"homebrew-volk.pth").write pth_contents
  end

  test do
    system "volk_modtool", "--help"
    system "volk_profile", "--iter", "10"
  end
end
