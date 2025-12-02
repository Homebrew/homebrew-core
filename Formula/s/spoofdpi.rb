class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://spoofdpi.xvzc.dev"
  url "https://github.com/xvzc/SpoofDPI/releases/download/v1.1.3/spoofdpi-1.1.3.tar.gz"
  sha256 "8baedfd4986ffbf19bcc56c874438b59aba13e95a237c8074aa73e4917806ffc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94b614c2d6b46f7ee88c0a7531d225b23deccd1925befa0e9cc1dad90f07a256"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a9306d630b165802c55063caaa6c2a8990ef92dec4133a69a72da78881e9f0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7909692327c9289e20bf0bf2ac9987c98008c668cdb7355b0c9b60ac3472c88"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b7e47fe8d7d0bc8e3e33b7dd2371276c21c9a101792cbd3ff0489cf7e3b377a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bd6b820e80d79033a14410efdca92037ca819ea6183c57c8383f0c151a5f740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5254cfd80725cc5877ad6427ceafaa6a10ff085be7454045469f1712c01e6f6b"
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
    pid = spawn bin/"spoofdpi", "--listen-port", port.to_s
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
