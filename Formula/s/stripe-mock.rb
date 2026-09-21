class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https://github.com/stripe/stripe-mock"
  url "https://github.com/stripe/stripe-mock/archive/refs/tags/v0.203.0.tar.gz"
  sha256 "33a312e15291d77d8448fb4155bf6a9e606973795f22f52562b0fec3fcc3a12f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "00544817f927f0d48e87428f190b2534fdfc2c76373ba22ea16ba106376d3a27"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a81f7c149e949a740128e1d3bd8280546ef20ceba66e522da3230ca062c82a7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a81f7c149e949a740128e1d3bd8280546ef20ceba66e522da3230ca062c82a7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "a81f7c149e949a740128e1d3bd8280546ef20ceba66e522da3230ca062c82a7e"
    sha256 cellar: :any_skip_relocation, sonoma:            "310e44eb83f80a2f6976f191244770a21f2b61638696e2ca5bb55f5ed7ea1432"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dfaa520eb649d46ce9ff38425b5893d91e1c2bc96383f00af9873f552f86082d"
    sha256 cellar: :any,                 x86_64_linux:      "aa3a1f890edb1e3b65a01ec5eb57129ad44e0cecc0d4719e8012e3a7015b4c56"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  service do
    run [opt_bin/"stripe-mock", "-http-port", "12111", "-https-port", "12112"]
    keep_alive successful_exit: false
    working_dir var
    log_path var/"log/stripe-mock.log"
    error_log_path var/"log/stripe-mock.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stripe-mock version")

    sock = testpath/"stripe-mock.sock"
    pid = spawn(bin/"stripe-mock", "-http-unix", sock)

    sleep 5
    assert_path_exists sock
    assert_predicate sock, :socket?
  ensure
    Process.kill "TERM", pid
  end
end
