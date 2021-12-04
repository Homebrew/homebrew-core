class Soapyplutosdr < Formula
  desc "Soapy SDR plugin for PlutoSDR"
  homepage "https://github.com/pothosware/SoapyPlutoSDR/wiki"
  url "https://github.com/pothosware/SoapyPlutoSDR/archive/soapy-plutosdr-0.2.1.tar.gz"
  sha256 "359e3762d98452b5e39078795b8165048e9edc8eb144d7c9bded7e1cc5358d4e"
  license "LGPL-2.1-only"
  head "https://github.com/pothosware/SoapyPlutoSDR.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "libad9361-iio"
  depends_on "libiio"
  depends_on "soapysdr"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Checking driver 'plutosdr'... PRESENT",
                 shell_output("#{Formula["soapysdr"].bin}/SoapySDRUtil --check=plutosdr")
  end
end
