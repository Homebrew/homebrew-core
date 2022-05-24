class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://github.com/gnuradio/volk/releases/download/v2.5.1/volk-2.5.1.tar.gz"
  sha256 "8f7f2f8918c6ba63ebe8375fe87add347046b8b3acbba2fb582577bebd8852df"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_monterey: "cd08be9bd078c3132652c270cfd6af087adc72855e36f2919e049d39fc22ba3a"
    sha256 arm64_big_sur:  "e7e77a6f19eaf1443460933a1937794300c76b00bc64fca7b0ebf9535e771f5e"
    sha256 monterey:       "0c8208cf15c8b3013fa8f1901fc06c0612458991a10e15db6f50744259e82e8e"
    sha256 big_sur:        "e5edefdbf14fdba429f56369c8c4b10f5fb7be7f5f3cd09a84d4542d0cd181a2"
    sha256 catalina:       "568e33a05f0a5efc390fd7181f1876bab39ca96abbbd9d9aca46027f61c540e8"
    sha256 x86_64_linux:   "985a55137a6942852d81447f577458d174979718475d60fc0e0cd9d2f4167fc5"
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
