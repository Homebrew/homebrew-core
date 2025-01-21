class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https://github.com/stripe/stripe-mock"
  url "https://github.com/stripe/stripe-mock/archive/refs/tags/v0.192.0.tar.gz"
  sha256 "9b38137b879d3c3b580ce6697dfe4de074a0178a7c96ea55502f26417b1e37e4"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2ba9c9c2bcf0036489d84d279a8c80bf7d72d483112bb6db13e1a78d89e156d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2ba9c9c2bcf0036489d84d279a8c80bf7d72d483112bb6db13e1a78d89e156d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2ba9c9c2bcf0036489d84d279a8c80bf7d72d483112bb6db13e1a78d89e156d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9df4eb35c18303d84efdc994c16aa5bf83c0a45175b1379d756ca08f73ab336"
    sha256 cellar: :any_skip_relocation, ventura:       "f9df4eb35c18303d84efdc994c16aa5bf83c0a45175b1379d756ca08f73ab336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d7cd69e545b5998185ed466614cf0c7bef58d33e38589be6caf94d52cd701be"
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
