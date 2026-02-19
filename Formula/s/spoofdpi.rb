class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://spoofdpi.xvzc.dev"
  url "https://github.com/xvzc/SpoofDPI/releases/download/v1.2.1/spoofdpi-1.2.1.tar.gz"
  sha256 "39cb201f8796c8a69b1fd58c38663eda61491c1440b5252c56b72b3f036fccb4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40a08acefbf566f815df741732f55fdbb0ad8701ac54a1e5470b65e1ccc0f860"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c07389a92221d43cac32b3db8fbd67a3b25110966d04813f72f7275bf6b5a4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5311777a665f460bd3723bf4bb184953f17d6d3652ae9282abb5e00c75894fc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccb0d0c4db0886e7ad706427a12b039f410e5db2aa89a9a07c8643211485a6f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c9a8b5cd47ae4fd4b5ef068ee531fa87fee3e420c2b3cc43999d5b7feac9590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b1e53d83d9af5c6366b4cc892b86f4322a6f403c1e34e5ff069b694865df5f7"
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
