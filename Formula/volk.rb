class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://github.com/gnuradio/volk.git",
      tag:      "v2.5.0",
      revision: "237a6fc9242ea8c48d2bbd417a6ea14feaf7314a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 monterey:     "5461f0cc22da460567168e94b836d4c946ad57e3dad48d6f616b88e1eecae77e"
    sha256 big_sur:      "13397948c2762d27f80e47fa13ef95930aea8a1b9221ca266f34de6f052890e8"
    sha256 catalina:     "e1fce59ef2e0308beb2688319d62cce2086159f792838e97d82315fab965c24c"
    sha256 mojave:       "7e2e2549521877c836c6b2c806f52c6256a9bc43c1d82b1f0edbbce0338bd512"
    sha256 x86_64_linux: "676c8cf00523f1c0771276bbcb9c99e2d465b2bf8d9d887b4fe03b8a3a524618"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "orc"
  depends_on "python@3.9"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # https://github.com/gnuradio/volk/issues/375

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
