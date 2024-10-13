class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https://github.com/stripe/stripe-mock"
  url "https://github.com/stripe/stripe-mock/archive/refs/tags/v0.190.0.tar.gz"
  sha256 "0506d442f7b60aa6a78374ea3b4c6a7f33c62589f0d1409a80ab4269d50bd0f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8a8c5c4034aa499e00fad295890cd3cdd366483489286c9a6f32d34e21897ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8a8c5c4034aa499e00fad295890cd3cdd366483489286c9a6f32d34e21897ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8a8c5c4034aa499e00fad295890cd3cdd366483489286c9a6f32d34e21897ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "23d70f0364a94695b38f0e637abd2c1012c75e3d31313ca5b113caa6ff722405"
    sha256 cellar: :any_skip_relocation, ventura:       "23d70f0364a94695b38f0e637abd2c1012c75e3d31313ca5b113caa6ff722405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1d39e91c3b46d97e3ea04e14f48301c4d7dab95cbf5d4b8489c3902d4265e2f"
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
