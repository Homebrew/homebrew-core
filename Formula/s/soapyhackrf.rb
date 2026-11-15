class Soapyhackrf < Formula
  desc "SoapySDR HackRF module"
  homepage "https://github.com/pothosware/SoapyHackRF/wiki"
  url "https://github.com/pothosware/SoapyHackRF/archive/refs/tags/soapy-hackrf-0.3.6.tar.gz"
  sha256 "7bdecb65074f0c30af707234fbb970687626d4b6e1768592325aa706ae46e572"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1fbcc99160d7219dc96156926415df3d6a159b37d1201d691b9bdb0cff19aec0"
    sha256 cellar: :any, arm64_tahoe:       "68bdf01229a87f5ec021931df385772da1e30fb70a98cf5b47cd34d551d5db4b"
    sha256 cellar: :any, arm64_sequoia:     "c667a5ad50c012d56cb279f63ddf3c9e750c5ad92ae4be6f7b225cfe53d53af0"
    sha256 cellar: :any, arm64_linux:       "200822fa2a81f3579fca9ac37c1fe1f1a99bfb018ece21da7e73a609fe8ce566"
    sha256 cellar: :any, x86_64_linux:      "0597917c4513c87aa1c1c3f62dcecc681ceb7a65c5f34f094208f40f0122c3a7"
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
