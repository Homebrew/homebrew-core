class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https://github.com/stripe/stripe-mock"
  url "https://github.com/stripe/stripe-mock/archive/refs/tags/v0.206.0.tar.gz"
  sha256 "113395fa2cbb0775f241070d9c4d956ef9e762ce54c4ea2bc10b1e801cacb8c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d5107d95f8c6e8b03e76439940646e8a55637b952a409811ccb81551c085cd2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d5107d95f8c6e8b03e76439940646e8a55637b952a409811ccb81551c085cd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d5107d95f8c6e8b03e76439940646e8a55637b952a409811ccb81551c085cd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5b046274af31c50276abc908af5a652cf7d25ca955ae41ec54e7f244ca7e845b"
    sha256 cellar: :any,                 x86_64_linux:      "01a82583ecda34523e3e78df5cdaf3b436d2452baec15fc4e9ff883a62d71b74"
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
