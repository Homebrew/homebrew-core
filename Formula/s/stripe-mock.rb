class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https://github.com/stripe/stripe-mock"
  url "https://github.com/stripe/stripe-mock/archive/refs/tags/v0.186.0.tar.gz"
  sha256 "16367a39793144e7a5c59170695b42face0b97328c811a7cd816d0bf4fc06a28"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09f9c37d683a9d022f898a2091633b9b8110926b9840c201532b88f3530b9862"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e845cb069dbf28699982063b023b852aa0d94aa3deaad66c995a486d2d9ae394"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d242c78b05f0bdff216b437bddefca3775a0082f8abdb6e5afe7db47ebee2672"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbd0e44ce2b0176ece1e3b1ac946c19e9eb6f7c94d1188373c5aab167be59de5"
    sha256 cellar: :any_skip_relocation, ventura:        "bf86591baa8417f93d7b7c02207ddee7f65259167ba1d33b1657656ce4a45931"
    sha256 cellar: :any_skip_relocation, monterey:       "4bcb342adfd0a0aaca13e8119232c4481d3168b8ba28e6f48a2f793e56fdf04f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dcddddf5ab0fd232a28b8d4eff90e92d1f355ddc241b48e2090cb0f4b2ef60b"
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
