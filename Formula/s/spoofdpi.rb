class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://spoofdpi.dev"
  url "https://github.com/xvzc/SpoofDPI/releases/download/v1.5.1/spoofdpi-1.5.1.tar.gz"
  sha256 "4bd43de5575aff15403a1d96d096d8c3ceefe17a54153d3b2c8d9ace8e96b389"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e233230e0955a72523c3946f90ed00ad0a34f9ef4265d7219c47b01317b98262"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8883c09e9d473b120b641d431ebfcdc16c4d0e0a2ee0b9f6286cfebda46b5aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8daadf2935e597ba92614218476f232302d1197caaffac930436dbad5177791b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5573e4511379f93efc9aac9fe46517ca8016171e60236890fd41b361fac75edf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80efaa47fbd93685217cdeebae326bd45c026a723829993f030e27d13e2a2534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4920b1b087b962ba5c99210626ce21a6ad65dbf636791d1179e2b1220c4d8899"
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
