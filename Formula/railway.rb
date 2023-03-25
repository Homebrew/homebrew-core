class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.0.18.tar.gz"
  sha256 "0d5477f722e58246c29b7ab8c35d11427bebc986341e0b39d01d9bbba7ecda57"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed279ef72dcb0761c5bc118478b92b914319c7e487cc6432cd555507ed1638b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c69cb9bfa0cf098ab5759d7d82cf9b2a94fb4828a52735123d4d43ef6d3bc934"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a7acc6a2a2aef8a3e29c1deaa03b1b440406aa7a4d77870cf5f9a932269c5e0"
    sha256 cellar: :any_skip_relocation, ventura:        "9a8e3fb412b122c3023db3e5a2c842271dc3034355963cd716afb0dc8dcb683a"
    sha256 cellar: :any_skip_relocation, monterey:       "1dc27d1d482bf6e206833c7f1989634b869e1cfb853d5cd191822c85fc14b82a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a729d1b728819f77b94ad5ffd706c92aa6caac7db87978c690f3e4c9a21772b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbc3a83606880521e94030c35f9cc392494d5e5c84187e1c72c436f212b0af69"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install shell completions
    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1)
    assert_match "Error: Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end
