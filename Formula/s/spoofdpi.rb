class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://spoofdpi.xvzc.dev"
  url "https://github.com/xvzc/SpoofDPI/releases/download/v1.3.1/spoofdpi-1.3.1.tar.gz"
  sha256 "124f4848c2b095538618071700780b506930d033e8a32ae9ba9b606ad66dd6b5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28123e574ccf48335c2d4c560a50592a2fd042a59d75d6fb817da0a4da444d94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72740fa322cfc0a1b51fddc770b4d7bcdd8685bee883714a08b8ceb7be85b794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e682f4b826303fa488859b011a970733876213948ea5702a37123f28f9858a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "14f0baf3ae84b12f86f95af9b9752da9a4321e8fcc9ac71f48f57e24682ce4c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "590d319b328c80b32d0ca618771da5b59a1c5150b578e85ca79dd7661ba96c79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd95cd2e5aa033a36b22511f336ffe541a8f4ab81dc69d3d307abde6ae2d3cd9"
  end

  depends_on "go" => :build

  def install
    # Disable CGO for Linux builds
    ENV["CGO_ENABLED"] = OS.linux? ? "0" : "1"

    # Prepare linker flags to inject version information
    ldflags = %W[
      -s -w
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
    pid = spawn bin/"spoofdpi", "--listen-addr", "127.0.0.1:#{port}"
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
