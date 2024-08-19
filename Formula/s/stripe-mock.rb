class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https://github.com/stripe/stripe-mock"
  url "https://github.com/stripe/stripe-mock/archive/refs/tags/v0.188.0.tar.gz"
  sha256 "07e334ce15b6d272e3ea937def404c67e953e3ac9362a344e2a81d4f3ce343f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ded02f29400324256a2be26681447156b7348f3be5f2e07e4adee9f38886852"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3908247f216711ac46ba909af4eb8390d57410c93ed4aa645e6f4c99811c7145"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "825d748efccaaead1c395ff3a86fd078c83d5e4bdb9de53e52abd52311d9e97b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4965c56bf280ecc0cae790c64e8371a2066dab2978961a1a2540adcc4a3be191"
    sha256 cellar: :any_skip_relocation, ventura:        "4d4b9013981f3bc90038c41475ebbb3b168bc433eb9ec0b1c21a2ccd60d1e6b3"
    sha256 cellar: :any_skip_relocation, monterey:       "8881df9658ca3b211597e4790792ebfa4a7a332fd24392759ae1d4c8d58e0707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abe3654fbbf646b501536c79cd1e9dfbc40a2beb9b2f443bf53f5dcbcadd3a88"
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
