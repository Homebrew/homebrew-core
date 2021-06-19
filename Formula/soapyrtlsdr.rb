class Soapyrtlsdr < Formula
  desc "SoapySDR RTL-SDR Support Module"
  homepage "https://github.com/pothosware/SoapyRTLSDR/wiki"
  url "https://github.com/pothosware/SoapyRTLSDR/archive/soapy-rtl-sdr-0.3.2.tar.gz"
  sha256 "d0335684179d5b0357213cc786a78d7b6dc5728de7af9dcbf6364b17e62cef02"
  license "MIT"
  head "https://github.com/pothosware/SoapyRTLSDR.git"

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
