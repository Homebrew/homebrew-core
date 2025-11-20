class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https://github.com/stripe/stripe-mock"
  url "https://github.com/stripe/stripe-mock/archive/refs/tags/v0.197.0.tar.gz"
  sha256 "66b00035b48c30711895a33adaa818b75f6a80d0ff5ffd77112da09e6ce626eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aaca3a9a06926c66f32aab1ad4d39b578b67c9d436bb04c0a8541d39f86d03c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaca3a9a06926c66f32aab1ad4d39b578b67c9d436bb04c0a8541d39f86d03c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aaca3a9a06926c66f32aab1ad4d39b578b67c9d436bb04c0a8541d39f86d03c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "634a5ec2315dec79294b0f5887b16798c011922920ef54e284efc2e646f50d45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e286bc6b84d0ab3a2ad5772bd76b87ab2ab2a1971cd3c75dee6fcb1f1e98d6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a42869e2470049cdb4f4263eb4bd07cd4cea13505bbba645a07fe946fab2aa46"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
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
