class Soapybladerf < Formula
  desc "Soapy SDR plugin for the Blade RF"
  homepage "https://github.com/pothosware/SoapyBladeRF/wiki"
  url "https://github.com/pothosware/SoapyBladeRF/archive/refs/tags/soapy-bladerf-0.4.1.tar.gz"
  sha256 "9f358dd59ba34a140597134ce72e80aa83f94b8b2c573a777d5f40364c7873bd"
  license "LGPL-2.1-only"

  depends_on "cmake" => :build
  depends_on "libbladerf"
  depends_on "soapysdr"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{Formula["soapysdr"].bin}/SoapySDRUtil --check=bladerf")
    assert_match "Checking driver 'bladerf'... PRESENT", output
  end
end
