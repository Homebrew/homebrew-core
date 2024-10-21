class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https://github.com/stripe/stripe-mock"
  url "https://github.com/stripe/stripe-mock/archive/refs/tags/v0.191.0.tar.gz"
  sha256 "0cdc81f97d2e803504000effcfdc8adb0c99abec57e8978ef4c0d1a2fa7f6f12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec99d037bd60cde64df53764a72f118f310287f7ac19ad13d07ae9e643344072"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec99d037bd60cde64df53764a72f118f310287f7ac19ad13d07ae9e643344072"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec99d037bd60cde64df53764a72f118f310287f7ac19ad13d07ae9e643344072"
    sha256 cellar: :any_skip_relocation, sonoma:        "053a237233899b1e9db37ab0e306b21d67880b1c86a395298233dafe6979163d"
    sha256 cellar: :any_skip_relocation, ventura:       "053a237233899b1e9db37ab0e306b21d67880b1c86a395298233dafe6979163d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "372f290c37b00be8f465597dee89eddf585d2cf11c7d26a86bfd3fa75786cf53"
  end

  depends_on "go" => :build

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
