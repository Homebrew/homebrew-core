class Soapybladerf < Formula
  desc "Soapy SDR plugin for the Blade RF"
  homepage "https://github.com/pothosware/SoapyBladeRF/wiki"
  url "https://github.com/pothosware/SoapyBladeRF/archive/soapy-bladerf-0.4.1.tar.gz"
  sha256 "9f358dd59ba34a140597134ce72e80aa83f94b8b2c573a777d5f40364c7873bd"
  license "MIT"
  head "https://github.com/pothosware/SoapyBladeRF.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "libbladerf"
  depends_on "soapysdr"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Checking driver 'bladerf'... PRESENT",
                 shell_output("#{Formula["soapysdr"].bin}/SoapySDRUtil --check=bladerf")
  end
end
