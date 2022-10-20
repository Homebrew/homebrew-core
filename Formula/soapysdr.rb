class Soapysdr < Formula
  desc "Vendor and platform neutral SDR support library"
  homepage "https://github.com/pothosware/SoapySDR/wiki"
  url "https://github.com/pothosware/SoapySDR/archive/soapy-sdr-0.8.1.tar.gz"
  sha256 "a508083875ed75d1090c24f88abef9895ad65f0f1b54e96d74094478f0c400e6"
  license "BSL-1.0"
  revision 1
  head "https://github.com/pothosware/SoapySDR.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b3a83674061e2817f0abf760a6cc8d5a41f892c4e5250b7e3d79043e1212bc18"
    sha256 cellar: :any,                 arm64_big_sur:  "e4a46ed92fa0825e14d95de3165aa221665085ea4318a90c9acc158a363c64fa"
    sha256 cellar: :any,                 monterey:       "786f24bf08521e2334e447ae16ad1b4e695463ce11910519bb884479418fac13"
    sha256 cellar: :any,                 big_sur:        "12198c0ad0281bf725073d507a78b2ac0b4d588d5106c0cbbbac0165641341ad"
    sha256 cellar: :any,                 catalina:       "6cbaeefa9a96dbcfc2466d6d2f4569c4b97db7c65ed70eac9b82a26ea0e51bba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce735644de57a1c3963e416c5767fc7918d56c916dbf5cb2f8b8077fcc277d65"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "python@3.10"

  def install
    args = %W[
      -DENABLE_PYTHON=OFF
      -DENABLE_PYTHON3=ON
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
  end
end
