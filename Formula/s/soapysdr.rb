class Soapysdr < Formula
  desc "Vendor and platform neutral SDR support library"
  homepage "https://github.com/pothosware/SoapySDR/wiki"
  url "https://github.com/pothosware/SoapySDR/archive/soapy-sdr-0.8.1.tar.gz"
  sha256 "a508083875ed75d1090c24f88abef9895ad65f0f1b54e96d74094478f0c400e6"
  license "BSL-1.0"
  revision 1
  head "https://github.com/pothosware/SoapySDR.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "6b73c034ca3f25efac4922bf336bff165074d79bc2ee0c276c74275728b81025"
    sha256 cellar: :any,                 arm64_monterey: "28ed02a75df0cafb919f0d9e30c0a312884762736868fe094fbaacec27bb12a8"
    sha256 cellar: :any,                 arm64_big_sur:  "d20855a9fdd81d185e576cd308b00ab1f657736c721167bdb61fc7ec2d17b507"
    sha256 cellar: :any,                 ventura:        "1479afce35a2e6b61412bd416041d85fe051a2ed6879734f6092c5fa1fe72f70"
    sha256 cellar: :any,                 monterey:       "9f3a6c8d3c6a9f0b8aaa9030da6d246dd40119309372bebc9e0952dc271d7dfe"
    sha256 cellar: :any,                 big_sur:        "3b7dfa0601c4c808ffb3f5195d1194f65adfb26a9182a8bd7ba61d0fdcd73202"
    sha256 cellar: :any,                 catalina:       "a47d2eca6bf6f4c4c4aaf15887cb2ac5ee22c0f6b1859e7bd2ec1d008fa19b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8708223be2fc61637991a16921166770a1977f19634aa61e4b7ec6473f0ee8e"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "python@3.11"

  def python3
    "python3.11"
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
