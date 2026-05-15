class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://spoofdpi.dev"
  url "https://github.com/xvzc/SpoofDPI/releases/download/v1.5.2/spoofdpi-1.5.2.tar.gz"
  sha256 "6847fd8f9b645178ec0056513d01bc657ee5efa7a34e418641243b459ccd8511"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f30aadc2198a830c7afbcf3ae77cee7b1d793a47ed35da022646aae94dc8f94d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92154552ed01f86e7826c03e5e719dddf274f47dd01be319be770204d67b7059"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "030dc6f6f158c4fa8fc538c4577ce25a328167804dc389d0ec666eaf65ab20e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf5021038e17b0a4a9d67f7b6377d7ff852187569cc79de7399b266b363ab5e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41c04f77ace14af317a2fe5ed09c572e1f9818df474b8498b7591c779a8d0a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92c03771d252a4124caa65a4bc68ee69cc27d91fb4b0414e8cb8845328c0f433"
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
