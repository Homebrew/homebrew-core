class Soapyrtlsdr < Formula
  desc "SoapySDR RTL-SDR Support Module"
  homepage "https://github.com/pothosware/SoapyRTLSDR/wiki"
  url "https://github.com/pothosware/SoapyRTLSDR/archive/soapy-rtl-sdr-0.3.2.tar.gz"
  sha256 "d0335684179d5b0357213cc786a78d7b6dc5728de7af9dcbf6364b17e62cef02"
  license "MIT"
  head "https://github.com/pothosware/SoapyRTLSDR.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f65a0f4e04096d104086f1f00896a635b722b06c0f88aa8a8842ba6bafce79d5"
    sha256 cellar: :any,                 arm64_big_sur:  "b27ae49c166978a6a923ea9113f052a6c46c97bf47da4c2e19b5fb39935501f2"
    sha256 cellar: :any,                 monterey:       "45b42c762bf369c97677466d6ee93e52a81c9a7adcaa19d04b6c751e5d0ce91a"
    sha256 cellar: :any,                 big_sur:        "451a1decca95bdec28c0159088ccdb7d2d70067aebc7edc92da99967db51e2fa"
    sha256 cellar: :any,                 catalina:       "77e5df3c37bcda727cf6cb04dff66aa0f196dda6503b886faf4892540bfca035"
    sha256 cellar: :any,                 mojave:         "62c8dd85c71bc5e119f4706b0288606f1613e26adbdd88303ded2098448bae9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b436aea3e9cbd452498651b3b3c1ac4fb46e66f631c4b22f6cb7250356729dc8"
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
