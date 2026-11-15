class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://spoofdpi.dev"
  url "https://github.com/xvzc/SpoofDPI/releases/download/v1.5.5/spoofdpi-1.5.5.tar.gz"
  sha256 "7aab199ffa2b356f9b89cbb01f352fcf1f907aed4424c0e65c6471007f9c9a57"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cfecb60f2c7a65d6deefe7e84ca0b8092f6069c612d3d351b22dab90e217772b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "03e29e3ddd92f6e96e132109cb9a8c5210b1c5d2c3aee23e06d9374932bdb8ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6c971621ac05a7e8a058c14a25708d937b245830ae912c2aeea57f5c1df4bf7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "851cac6fede0cd33245591a4697780b2036e47f38ada14d3a7661bcd66f07c6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4850a4d1d1e2a5a40f28b858661a0083e2156efdf10f987761f6d0b0c4e5dc4b"
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
