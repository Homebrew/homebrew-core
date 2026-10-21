class Soapyremote < Formula
  desc "Use any Soapy SDR remotely"
  homepage "https://github.com/pothosware/SoapyRemote/wiki"
  url "https://github.com/pothosware/SoapyRemote/archive/refs/tags/soapy-remote-0.5.3.tar.gz"
  sha256 "de5bdf209dc93bf7c341077e1e21353037fc387e7c6a9ee41eace3390669dcc1"
  license "BSL-1.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "959e8c989590505c99f5689c2ad84e6a320a71d467c7932cdb8e40eb4db9030f"
    sha256 cellar: :any, arm64_tahoe:       "55e369064ec119a4dfa60c431cd91731f5b18c297370f7b8d3b5788130f91d09"
    sha256 cellar: :any, arm64_sequoia:     "feb1662facc60fb7d3b6a75500b688700887ddcfbf1559b3e31d519a39e27139"
    sha256 cellar: :any, arm64_linux:       "b01873eb5becf5e4e601abf7ba8ada34d697ef0014496291889b86b5750846dc"
    sha256 cellar: :any, x86_64_linux:      "129c00a601d93b2fb46e25a6dd46d73016de1ccddf828658e09ce390d560215f"
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
