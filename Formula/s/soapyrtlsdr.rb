class Soapyrtlsdr < Formula
  desc "SoapySDR RTL-SDR Support Module"
  homepage "https://github.com/pothosware/SoapyRTLSDR/wiki"
  url "https://github.com/pothosware/SoapyRTLSDR/archive/refs/tags/soapy-rtl-sdr-0.3.3.tar.gz"
  sha256 "757c3c3bd17c5a12c7168db2f2f0fd274457e65f35e23c5ec9aec34e3ef54ece"
  license "MIT"
  revision 1
  head "https://github.com/pothosware/SoapyRTLSDR.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "67a24a0b9ea8b7e000cb5b29b9a84048268c31e621a2c406b8d4bcaff94d08d5"
    sha256 cellar: :any,                 arm64_ventura:  "8b8e0295ac33eed6289a6a14127c7db8adf2c982bb12fa39cf13e527137bb144"
    sha256 cellar: :any,                 arm64_monterey: "c1da93795e2bbf36a23cef4c88894aaf13c110b35f76644090d9d6d1b112f82f"
    sha256 cellar: :any,                 sonoma:         "9ad8d51a7017676bd4a86b01de233c3e1543e0e63e92bd49a317f249a2d33734"
    sha256 cellar: :any,                 ventura:        "53587da93c3612d82b40ac515592fd444ec488db1aa29807352afdf9bcc67909"
    sha256 cellar: :any,                 monterey:       "0fc3c58bdaef48cf10e4853faa145ed4e3ddb7d9cdff82b27398ad26d7ffd521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac50a89b70e5d89d11d48ba05f19ba435df4a9d3c90fad9ab4d31e08efe6eb2f"
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
