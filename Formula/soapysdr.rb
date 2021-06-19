class Soapysdr < Formula
  desc "Vendor and platform neutral SDR support library"
  homepage "https://github.com/pothosware/SoapySDR/wiki"
  url "https://github.com/pothosware/SoapySDR/archive/soapy-sdr-0.8.0.tar.gz"
  sha256 "cff3b1fb1cd3b88932f37df42f69fc3d8e0ea42f4788b35131ceaf5d1b908ac2"
  license "BSL-1.0"
  head "https://github.com/pothosware/SoapySDR.git"

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
