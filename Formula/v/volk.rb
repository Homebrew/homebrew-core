class Volk < Formula
  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://github.com/gnuradio/volk/releases/download/v3.1.1/volk-3.1.1.tar.gz"
  sha256 "d8c25fad82243d69a653bb989eced8e404b12d7caec6baee16675ef9f77c27fa"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "24284980dcc4e4ca84e69971cb9e0e76074dc254e99d154313cb1f042b4e3a41"
    sha256 arm64_ventura:  "7860473a2423fff8b8451a72ebe073f9af9c167e466e6f1d66f7ebbb329a2d63"
    sha256 arm64_monterey: "949f40266fb5c32228d4fefec6fe2df0b5d7860a25bf42bfef632ec57465997a"
    sha256 sonoma:         "70ec53e6a7550a92abf9624c5bb94101be056c0e9aef3006655bf5865fb1600e"
    sha256 ventura:        "61c6089e5722d5d401ed11306d02f527dee70843ca2d14eea04a257ab2882874"
    sha256 monterey:       "9621aca1cb1b6c30c7cc1efd2b18b2993792d00e83b3085c41d30c463e161b1b"
    sha256 x86_64_linux:   "479022931d91f7caa758f0933962445570eaf15153fbc90518e59b5c60c2adde"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "pygments"
  depends_on "python-mako"
  depends_on "python-markupsafe"
  depends_on "python@3.12"

  on_intel do
    depends_on "cpu_features"
  end

  fails_with gcc: "5" # https://github.com/gnuradio/volk/issues/375

  # see discussions in https://github.com/gnuradio/volk/issues/745
  patch do
    url "https://github.com/gnuradio/volk/commit/bc59cad9dcde3865f87b71988634109bd3b6fb1c.patch?full_index=1"
    sha256 "52476d6ee7511ead8ee396f9f1af45bcd7519a859b088418232226c770a9864a"
  end

  def install
    python = "python3.12"

    # Avoid references to the Homebrew shims directory
    inreplace "lib/CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    # cpu_features fails to build on ARM macOS.
    args = %W[
      -DPYTHON_EXECUTABLE=#{which(python)}
      -DENABLE_TESTING=OFF
      -DVOLK_CPU_FEATURES=#{Hardware::CPU.intel?}
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/volk_modtool", "--help"
    system "#{bin}/volk_profile", "--iter", "10"
  end
end
