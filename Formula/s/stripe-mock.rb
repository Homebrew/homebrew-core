class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https://github.com/stripe/stripe-mock"
  url "https://github.com/stripe/stripe-mock/archive/refs/tags/v0.194.0.tar.gz"
  sha256 "8e6357d75ef58badc91995c3a4f6bad6825384461ec3ccdf2c780e3798951733"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83a4f61d0c6e07b281dbeb8ef2dfba7d6bdddc5586b21cfc504f94e0aa0a58c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83a4f61d0c6e07b281dbeb8ef2dfba7d6bdddc5586b21cfc504f94e0aa0a58c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83a4f61d0c6e07b281dbeb8ef2dfba7d6bdddc5586b21cfc504f94e0aa0a58c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "779a14948e1bd5c4504b56fb2b615251e68676419285b1f360bf579681cc3d06"
    sha256 cellar: :any_skip_relocation, ventura:       "779a14948e1bd5c4504b56fb2b615251e68676419285b1f360bf579681cc3d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "766d65a5aec06f7df1da89b06ec455321d4b78194cf47b3c6a5692ebb2b0c778"
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
