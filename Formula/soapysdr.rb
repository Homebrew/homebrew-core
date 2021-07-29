class Soapysdr < Formula
  desc "Vendor and platform neutral SDR support library"
  homepage "https://github.com/pothosware/SoapySDR/wiki"
  url "https://github.com/pothosware/SoapySDR/archive/soapy-sdr-0.8.1.tar.gz"
  sha256 "a508083875ed75d1090c24f88abef9895ad65f0f1b54e96d74094478f0c400e6"
  license "BSL-1.0"
  head "https://github.com/pothosware/SoapySDR.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d93fdc3756fd6036c4e429e48e29df9dae3ba201fe049814fbd56d420a8cd3db"
    sha256 cellar: :any, big_sur:       "3c548da2b3d9c65c3a57a96a7cf4c0750a897ed813b44cb3b1af9364803e38c8"
    sha256 cellar: :any, catalina:      "87d3d2fd8d8b76cd01151395a9fa8c482db9508933c991cbdd29dcdf07ce5b68"
    sha256 cellar: :any, mojave:        "fdb7072edfc170aa7aa5bff1411f6797701500968f318be6ea7b2bfc119198e2"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "python@3.9"

  def install
    args = std_cmake_args + %W[
      -DENABLE_PYTHON=OFF
      -DENABLE_PYTHON3=ON
      -DSOAPY_SDR_ROOT=#{HOMEBREW_PREFIX}
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DSOAPY_SDR_EXTVER=release" unless build.head?

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match "Loading modules... done", shell_output("#{bin}/SoapySDRUtil --check=null")
  end
end
