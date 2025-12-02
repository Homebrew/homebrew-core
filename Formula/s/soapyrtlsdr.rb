class Soapyrtlsdr < Formula
  desc "SoapySDR RTL-SDR Support Module"
  homepage "https://github.com/pothosware/SoapyRTLSDR/wiki"
  url "https://github.com/pothosware/SoapyRTLSDR/archive/refs/tags/soapy-rtl-sdr-0.3.3.tar.gz"
  sha256 "757c3c3bd17c5a12c7168db2f2f0fd274457e65f35e23c5ec9aec34e3ef54ece"
  license "MIT"
  revision 2
  head "https://github.com/pothosware/SoapyRTLSDR.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "48f1464d0739465385b31f436ae6f9ea01ce68132730976767238c830f13c318"
    sha256 cellar: :any,                 arm64_sequoia:  "76b22eaf2c71839e2f26068ed671fd7652ed7aac92b582cbc267159d0fb851ca"
    sha256 cellar: :any,                 arm64_sonoma:   "3b758a501acd8918eddee8cd29669fdbfecb4bfb1c0a1363290ff2534dce9ffe"
    sha256 cellar: :any,                 arm64_ventura:  "a2deb76bc7882fd8cdc38c11408c0228a99ae91e8e2165ccd27c4fc1aaa908ff"
    sha256 cellar: :any,                 arm64_monterey: "2968a2967fc49780b5c5a7f0278bb38f7f13f424413389e05a42e807682e27db"
    sha256 cellar: :any,                 sonoma:         "984fedf5e1b8712bacc86a3e2fcb225233dbd751955e17f61896cdd8cb811cb5"
    sha256 cellar: :any,                 ventura:        "24c80a7bae5a8ff939c51914fd86ec146b9f8f03f274cf5c4d428ff6273d4f18"
    sha256 cellar: :any,                 monterey:       "3ab1e0c54d417347e2439daf45f6859f2669fcfbd8fa061cc18741614fc7cb2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "17be80002546fb45015241d6c2e4de81d93067637128c4137a2e21035236d6be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4169428867a8b2d9fa11b6f601c735b8c2d5ffa0f46d3289cd1d1f58dfea6dc"
  end

  depends_on "cmake" => :build
  depends_on "librtlsdr"
  depends_on "soapysdr"

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{Formula["soapysdr"].bin}/SoapySDRUtil --check=rtlsdr")
    assert_match "Checking driver 'rtlsdr'... PRESENT", output
  end
end
