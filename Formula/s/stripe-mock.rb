class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https://github.com/stripe/stripe-mock"
  url "https://github.com/stripe/stripe-mock/archive/refs/tags/v0.199.0.tar.gz"
  sha256 "c0ad9d71656cc42dca9055a35fbcf3b5910f3ead3f04c7f2473c682ab3d55eef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89a448ce245d332667812752611deafdeccd4ea2f6ada31d4b3a12374d6af870"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89a448ce245d332667812752611deafdeccd4ea2f6ada31d4b3a12374d6af870"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89a448ce245d332667812752611deafdeccd4ea2f6ada31d4b3a12374d6af870"
    sha256 cellar: :any_skip_relocation, sonoma:        "da853eee894e22557ea070aa9b006f54791577e0d3d2c3fe50925d2d95fc6910"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "122d455d39d5b05c5d8a9e18e0a9b76965be208cb95cdd1d41e7df469902d281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "203efa75d6b1596d67960ea1de1a65196754c5f6ec25ef2e9c10d04235e66eba"
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
