class Soapyremote < Formula
  desc "Use any Soapy SDR remotely"
  homepage "https://github.com/pothosware/SoapyRemote/wiki"
  url "https://github.com/pothosware/SoapyRemote/archive/refs/tags/soapy-remote-0.5.4.tar.gz"
  sha256 "7109077f9f64c530c26604d2f30437d4403d6133df50e600c3c7e022a622521c"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4943dfc0d665c54bba5e24601133e351172911e2310ba7fde0b44155361680b5"
    sha256 cellar: :any, arm64_tahoe:       "611bd6e2f6785920e55bed0bee8ef652dc31ff4d53640f88a091f4db7d406692"
    sha256 cellar: :any, arm64_sequoia:     "6e62f4dc506f0d52211ac5368cbda8a6ef88c74617086ebd1cdb2d97c9e34b8f"
    sha256 cellar: :any, arm64_linux:       "3e40f55fb2cb25402275ddf56ede8cd0d83419d9b51c3d589aa9f26703b3e559"
    sha256 cellar: :any, x86_64_linux:      "9614ce6c5dc95128b542ceb41ab2365bbe46626ebdc372af40bcd64c7d86e2cc"
  end

  depends_on "cmake" => :build
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
    output = shell_output("#{formula_opt_bin("soapysdr")}/SoapySDRUtil --check=remote")
    assert_match "Checking driver 'remote'... PRESENT", output
  end
end
