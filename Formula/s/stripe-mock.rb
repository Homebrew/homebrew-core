class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https://github.com/stripe/stripe-mock"
  url "https://github.com/stripe/stripe-mock/archive/refs/tags/v0.196.0.tar.gz"
  sha256 "75d4fb1d8ed01f68a8972a84fa6c7697ad89750f5e082c2482b363d812822c27"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e71d28a262899dd6731b0533654efc38c972b4ba1ee34fd34d9cfc9f32957db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e71d28a262899dd6731b0533654efc38c972b4ba1ee34fd34d9cfc9f32957db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e71d28a262899dd6731b0533654efc38c972b4ba1ee34fd34d9cfc9f32957db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e71d28a262899dd6731b0533654efc38c972b4ba1ee34fd34d9cfc9f32957db"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d8fcf7c626d61d83dec91f29f0b7a117d976b39b1868f9971feeac4723fe241"
    sha256 cellar: :any_skip_relocation, ventura:       "1d8fcf7c626d61d83dec91f29f0b7a117d976b39b1868f9971feeac4723fe241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ca0f2cb78497879322ff49313a691ad7d2a93b80bfabe1ab3084aafd89c1862"
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
