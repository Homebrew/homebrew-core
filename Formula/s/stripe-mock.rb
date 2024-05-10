class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https://github.com/stripe/stripe-mock"
  url "https://github.com/stripe/stripe-mock/archive/refs/tags/v0.185.0.tar.gz"
  sha256 "cd14f2ebed4c72d172bf3d22d295747a5f6bbc01770242283f54f7702c53db0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e753fbe515f1f6f46e366555798c98cdf9ac29217d24532ac9d07e8d39ba384b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eef1dbf813f8cdeeb33849a73b90581c58de92feddaf1a442b3f898a8845fdb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de69475bc3d5b237b9668e2912ee4a52f2ec30ab377a70b0d883e158facfb64d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c35c7db4e731f9bf2f6bc5136609ecfc4f51fec93867dcd4b3c5c88eeb973ed8"
    sha256 cellar: :any_skip_relocation, ventura:        "c558cb21081b2b575081936ff11fcc457dfa1d86e32edd7fcb6b8c102ab6d97f"
    sha256 cellar: :any_skip_relocation, monterey:       "7ea67887c98f951b90f34496cfb81e28660f75bcd2817368ed9b63bdd55b919e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abf4e66e45edc625b364ed88b51fbcd45ab8343d6bd6279f8f7a81bcae88472b"
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
