class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://spoofdpi.dev"
  url "https://github.com/xvzc/SpoofDPI/releases/download/v1.5.3/spoofdpi-1.5.3.tar.gz"
  sha256 "5c948c8969411dbc0482d62c8ebb19a1d0e4d64aec7753ed673b686c65dae4d8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e631168212bca6fec6f132de41ba3339085432b9a34724b7eb3dbb6e7950122"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59fe319df1427800638209c50a6f2cb78a8476e85c39868c74515c2ba064a9d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc77553af4edfe22b9791ce8e2e6586a1f894e7a3a647199157509581b148cfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "810d35048180d765431b7797892b55f6e6f039a9fb12187acaa97c722315483e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e1e998d069638b33eeb9c5de62d44844b8f83b43ca83a11b300da4f3edc16e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8930ac9608dc25b6677ea0e2f17d09f1a939c30883eed01752f18a8517e4ae71"
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
