class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://spoofdpi.dev"
  url "https://github.com/xvzc/SpoofDPI/releases/download/v1.6.0/spoofdpi-1.6.0.tar.gz"
  sha256 "186e9556b81844e2076ce8426b741fd1436ec987c4eb855de67b9254520675a3"
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
    manifest_sha256 "6a70725e93725b7a45931ea35ba9f2150ba6f9de4caa30acd816de0d749e80c8"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b22fc3d0c66d93779528248551e9ad20039440f213f427d39c142322be80b16a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "12a16c25a4a107e85ffe4f8da8d1992d0b4f48943782ac47a64a20bb259248b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "219566ce9b0ae316ff0f88f81484fef7ec624241138d463708fe27323c3040ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "81804afedc286e0e2975f6eb480cc547049e55672894c2454281688f8f03bcda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f5f9f426f79370ed39ba5d6621fd512125a0199bda06896cd7db22fb70b6ef34"
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
