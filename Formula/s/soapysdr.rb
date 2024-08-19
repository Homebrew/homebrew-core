class Soapysdr < Formula
  desc "Vendor and platform neutral SDR support library"
  homepage "https://github.com/pothosware/SoapySDR/wiki"
  url "https://github.com/pothosware/SoapySDR/archive/refs/tags/soapy-sdr-0.8.1.tar.gz"
  sha256 "a508083875ed75d1090c24f88abef9895ad65f0f1b54e96d74094478f0c400e6"
  license "BSL-1.0"
  revision 1
  head "https://github.com/pothosware/SoapySDR.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "ee59200eb0b063923ca172880d6242df8a0bd7ff193b42f0f559a3ccbae5ecb5"
    sha256 cellar: :any,                 arm64_ventura:  "e25dda6534a1db99e4733c373f83bb280afeb46927a19d64c4cdb2208a769e99"
    sha256 cellar: :any,                 arm64_monterey: "72b5f1b5b3b5558d99173774621de43d9880a6141075fb6d3752fdb437c84ed3"
    sha256 cellar: :any,                 sonoma:         "7bb7356090f0398c9ace3fd4067122925581dbd83de3b9465d83bd572e38eae9"
    sha256 cellar: :any,                 ventura:        "403895702ca2e9225a66b01ddfd0e69ba0aab0dd5df105812780e70142c48703"
    sha256 cellar: :any,                 monterey:       "a6018b446f7827ef40e21a60f40b401fc85da58b65ef0a5905174c8eae926744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f10dcf27a18c96fcdd36c27ab64bfd87dd38285117d142399a038e76de230c2"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    args = %W[
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DSOAPY_SDR_ROOT=#{HOMEBREW_PREFIX}
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DSOAPY_SDR_EXTVER=release" unless build.head?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Loading modules... done", shell_output("#{bin}/SoapySDRUtil --check=null")
    system python3, "-c", "import SoapySDR"
  end
end
