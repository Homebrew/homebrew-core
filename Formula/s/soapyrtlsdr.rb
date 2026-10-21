class Soapyrtlsdr < Formula
  desc "SoapySDR RTL-SDR Support Module"
  homepage "https://github.com/pothosware/SoapyRTLSDR/wiki"
  url "https://github.com/pothosware/SoapyRTLSDR/archive/refs/tags/soapy-rtlsdr-0.3.4.tar.gz"
  sha256 "1602035b849bca2e9c189712a08d22dc0c7c3a936f9063ac9851bf3229d4460e"
  license "MIT"
  head "https://github.com/pothosware/SoapyRTLSDR.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "136c704cbf3dc9d6fc14abfdb7cc0cd932da3d2ce599e9181edb1c976c039ca4"
    sha256 cellar: :any, arm64_tahoe:       "309c2ad92ab86080e8d531570758962b3ce31ff83aa0f33b486637ed1a8a3fd8"
    sha256 cellar: :any, arm64_sequoia:     "25919bc08646a423801c31624bedac3fcbabb7ea697cb66fe8f774dd2dc39aa2"
    sha256 cellar: :any, arm64_linux:       "bb045b2445af5b1794977354c6fab9585ec1ef2e0c3e0eb743b3e6c05216967d"
    sha256 cellar: :any, x86_64_linux:      "d2e78c02527ada8824f35a04f373913f63126146f851e22785e541f3707dde99"
  end

  depends_on "cmake" => :build
  depends_on "librtlsdr"
  depends_on "soapysdr"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{formula_opt_bin("soapysdr")}/SoapySDRUtil --check=rtlsdr")
    assert_match "Checking driver 'rtlsdr'... PRESENT", output
  end
end
