class Soapyhackrf < Formula
  desc "SoapySDR HackRF module"
  homepage "https://github.com/pothosware/SoapyHackRF/wiki"
  url "https://github.com/pothosware/SoapyHackRF/archive/refs/tags/soapy-hackrf-0.3.4.tar.gz"
  sha256 "c7a1b8aee7af9d9e11e42aa436eae8508f19775cdc8bc52e565a5d7f2e2e43ed"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "9c90ca14cff4f27d529309b308ab277e65d808dc90500641162c395784efbb9e"
    sha256 cellar: :any,                 arm64_sequoia:  "8be1e7bcc5b9e130dab78d35843ae04e015dd65417fa15fc61206303605aaed4"
    sha256 cellar: :any,                 arm64_sonoma:   "d4adb509c27bb07ce14004434db28bb1061139cc012b7e7eb02a696807057204"
    sha256 cellar: :any,                 arm64_ventura:  "c05011b63cf35c0c0b4ab594809e4445f89850573ca8c47137078972c995ac2d"
    sha256 cellar: :any,                 arm64_monterey: "3506a45c3e3d8efaf558f72dd8d2f748f1e386878cb451ae4d2fd39ddc4873f9"
    sha256 cellar: :any,                 sonoma:         "0e13b5a64f3a5038879c929a4108ac9d5d9c2804b7e949816a4645d9edfbcdef"
    sha256 cellar: :any,                 ventura:        "04e3a1b7d8dd0b7c27dd2c4f20846c88783922e8cdbdcd4da12768ade7af6373"
    sha256 cellar: :any,                 monterey:       "8d1e0b4696c0af821c08789a1dc354628c8a9afdf4752842fb99fd364c6778e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "aac2cfd5a931da22b6fa5bff2e99982da69875261ff6f2b5106f45b233294dbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8112b3fa519d4f5c319c0dfc36fff70131a54e39616bdf9378ed4625f142374"
  end

  depends_on "cmake" => :build
  depends_on "hackrf"
  depends_on "soapysdr"

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{Formula["soapysdr"].bin}/SoapySDRUtil --check=hackrf")
    assert_match "Checking driver 'hackrf'... PRESENT", output
  end
end
