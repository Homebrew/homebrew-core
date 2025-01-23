class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://github.com/xvzc/SpoofDPI"
  url "https://github.com/xvzc/SpoofDPI/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "8350cacb0a5cc7b3c1d9aa7cbd2e519dfb61e7d59d49475de11387f8229a01c0"
  license "Apache-2.0"
  head "https://github.com/xvzc/SpoofDPI.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e6cb2bc9d9a3bff09bf9e2a32b174654ce7379fc141918f512fb6f32bc54d359"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6cb2bc9d9a3bff09bf9e2a32b174654ce7379fc141918f512fb6f32bc54d359"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6cb2bc9d9a3bff09bf9e2a32b174654ce7379fc141918f512fb6f32bc54d359"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6cb2bc9d9a3bff09bf9e2a32b174654ce7379fc141918f512fb6f32bc54d359"
    sha256 cellar: :any_skip_relocation, sonoma:         "28532b6f63c37431c6159c59707c6763f6788a3f8eded481a7ccf79f8b976683"
    sha256 cellar: :any_skip_relocation, ventura:        "28532b6f63c37431c6159c59707c6763f6788a3f8eded481a7ccf79f8b976683"
    sha256 cellar: :any_skip_relocation, monterey:       "28532b6f63c37431c6159c59707c6763f6788a3f8eded481a7ccf79f8b976683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16de959e4dd509269fb41e71a1fd3948581c3844b2ae035506d478313b09d615"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/spoofdpi"
  end

  service do
    run opt_bin/"spoofdpi"
    keep_alive successful_exit: false
    log_path var/"log/spoofdpi/output.log"
    error_log_path var/"log/spoofdpi/error.log"
  end

  test do
    port = free_port
    pid = spawn bin/"spoofdpi", "-system-proxy=false", "-port", port.to_s
    begin
      sleep 3
      # "nothing" is an invalid option, but curl will process it
      # only after it succeeds at establishing a connection,
      # then it will close it, due to the option, and return exit code 49.
      shell_output("curl -s --connect-timeout 1 --telnet-option nothing 'telnet://127.0.0.1:#{port}'", 49)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
