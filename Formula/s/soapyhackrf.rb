class Soapyhackrf < Formula
  desc "SoapySDR HackRF module"
  homepage "https://github.com/pothosware/SoapyHackRF/wiki"
  url "https://github.com/pothosware/SoapyHackRF/archive/refs/tags/soapy-hackrf-0.3.5.tar.gz"
  sha256 "0ef13ac8cf1ec0c0728bdfe8a775e38fd06574418948e3a30ea6794de5d5a06c"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1d5bf30e18eaa40c2323af3b8a7465b7fdcb7345220ec849d471dd47e17722b3"
    sha256 cellar: :any, arm64_tahoe:       "75dcf5f5a534104f184ce65153ba4d526f5391215bcb03a01e8dd96bb1c8e7ab"
    sha256 cellar: :any, arm64_sequoia:     "4296fa789a891773e8e9cabe22490c27256a50817d4b930edd404cff8ff54733"
    sha256 cellar: :any, arm64_linux:       "1b77e89175bfe20e8b72a70269cddc2d246eba423e5c83ad14f4d167378f41a6"
    sha256 cellar: :any, x86_64_linux:      "19a38fce66f86f8e4127458b556b764f1354456b0b2c9c93de70891beb621abe"
  end

  depends_on "cmake" => :build
  depends_on "hackrf"
  depends_on "soapysdr"

  deny_network_access!

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{formula_opt_bin("soapysdr")}/SoapySDRUtil --check=hackrf")
    assert_match "Checking driver 'hackrf'... PRESENT", output
  end
end
