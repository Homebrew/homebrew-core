class Soapyrtlsdr < Formula
  desc "SoapySDR RTL-SDR Support Module"
  homepage "https://github.com/pothosware/SoapyRTLSDR/wiki"
  url "https://github.com/pothosware/SoapyRTLSDR/archive/soapy-rtl-sdr-0.3.3.tar.gz"
  sha256 "757c3c3bd17c5a12c7168db2f2f0fd274457e65f35e23c5ec9aec34e3ef54ece"
  license "MIT"
  head "https://github.com/pothosware/SoapyRTLSDR.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "922896ad8d6c44fed91b627c48e740fc797edce83232dc3bb287e325061f2eaf"
    sha256 cellar: :any,                 arm64_big_sur:  "11c9ba0104eb65d314c06801c54e7c043740a150243a5d08abbf8689c221193a"
    sha256 cellar: :any,                 monterey:       "122ed46b2d8ce6a0b47c5d8d25ba9faa8fe4ad0d54f9d3ebc1192d9f6163bfe2"
    sha256 cellar: :any,                 big_sur:        "cf8d5bee0688736dfc54b35d003e181f479b0a86e3d82b538f87daa401eaee60"
    sha256 cellar: :any,                 catalina:       "bfe8b9cac1848868e63cd1226886e0d6c9e3e84dab9f546245f157202e03a232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37726a74b5a58d6a59cdf5590797c98f8c293e5536a82d2c21d902b16ff79103"
  end

  depends_on "cmake" => :build
  depends_on "librtlsdr"
  depends_on "soapysdr"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Checking driver 'rtlsdr'... PRESENT",
                 shell_output("#{Formula["soapysdr"].bin}/SoapySDRUtil --check=rtlsdr")
  end
end
