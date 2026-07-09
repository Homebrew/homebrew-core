class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https://github.com/stripe/stripe-mock"
  url "https://github.com/stripe/stripe-mock/archive/refs/tags/v0.201.0.tar.gz"
  sha256 "2f6cad6954b5a9c47a6815f3c413d7c0584f90a6df0c28fd7488627492f19f2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce3ddace9e5e952128fc4bbee36f9a92ce3a02b0e947494f07540f25c0ee3140"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce3ddace9e5e952128fc4bbee36f9a92ce3a02b0e947494f07540f25c0ee3140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce3ddace9e5e952128fc4bbee36f9a92ce3a02b0e947494f07540f25c0ee3140"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce81b8d4cc4aae30bd7f11d290e1201c70c1b8caebe134d5a6401691aaf724ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68e4eeb593b0fa9131ee952dbacb7cead0dffb14f0c61eea87d1686c0be597db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c76a6e4220937a8b7063a1f8e01cec4b7fb85dd9727a3c74baf097a304d62f84"
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
