class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https://github.com/stripe/stripe-mock"
  url "https://github.com/stripe/stripe-mock/archive/refs/tags/v0.195.0.tar.gz"
  sha256 "830a70cdbefc14b77f1c397ed29b401ea79a8f2bfdc2bbf9708a901e17208559"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb00df69c89beb8cb7465d9aea84b30e20e669a320dfa1d1f2fde9f1a3f20734"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb00df69c89beb8cb7465d9aea84b30e20e669a320dfa1d1f2fde9f1a3f20734"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb00df69c89beb8cb7465d9aea84b30e20e669a320dfa1d1f2fde9f1a3f20734"
    sha256 cellar: :any_skip_relocation, sonoma:        "db97b4f234bf4e99abe4fcf7f94e23aa6c66613536875987d90cbb149b257bf3"
    sha256 cellar: :any_skip_relocation, ventura:       "db97b4f234bf4e99abe4fcf7f94e23aa6c66613536875987d90cbb149b257bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfb32a534ce1b0ab692a753f11cc4c00b28d05b0a161e472798c504f7d5f683a"
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
