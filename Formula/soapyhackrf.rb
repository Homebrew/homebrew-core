class Soapyhackrf < Formula
  desc "SoapySDR HackRF module"
  homepage "https://github.com/pothosware/SoapyHackRF/wiki"
  url "https://github.com/pothosware/SoapyHackRF/archive/soapy-hackrf-0.3.3.tar.gz"
  sha256 "7b24a47cee42156093bf82982b4fc6184a7c86101c3b8ee450274e57ee1c4b90"
  license "MIT"
  head "https://github.com/pothosware/SoapyHackRF.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "hackrf"
  depends_on "soapysdr"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Checking driver 'hackrf'... PRESENT",
                 shell_output("#{Formula["soapysdr"].bin}/SoapySDRUtil --check=hackrf")
  end
end
