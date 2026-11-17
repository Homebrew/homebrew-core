class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://spoofdpi.dev"
  url "https://github.com/xvzc/SpoofDPI/releases/download/v1.5.6/spoofdpi-1.5.6.tar.gz"
  sha256 "8a0d0834b3f25f450eb71f0fc9f0f60ab1c2005e390ea5210f32ba0e64a2521c"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f100eeec140272a5d2167dcaa5789187a00ae1c8d6bd3ea86fc5567fb51b7b6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ba4547fc2408d993b081c43d3751267a71468cdcf6db9fcc456aae30b2133b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1f4300d93c66ca32d34c7d9b438b7cc18881bc3102a43007d28e923b1484c143"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c79b11f17ab6a330e48ea8ff287a130e9c2babd484d5cb1a32cc9618a999b3c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "082dc94725c78b53b16c411979d3f33fc4f0ed381fdd17d7cddbd5f88608b92e"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Disable CGO for Linux builds
    ENV["CGO_ENABLED"] = OS.linux? ? "0" : "1"

    # Prepare linker flags to inject version information
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{File.read("COMMIT")}
      -X main.build=homebrew
    ]

    # Build directly from source
    system "go", "build", *std_go_args(ldflags:), "./cmd/spoofdpi"
  end

  service do
    run opt_bin/"spoofdpi"
    keep_alive successful_exit: false
    log_path var/"log/spoofdpi/output.log"
    error_log_path var/"log/spoofdpi/error.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spoofdpi -v")

    port = free_port
    pid = if OS.mac?
      spawn bin/"spoofdpi", "--listen-addr", "127.0.0.1:#{port}"
    else
      require "pty"
      PTY.spawn(bin/"spoofdpi", "--listen-addr", "127.0.0.1:#{port}").last
    end

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
