class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://github.com/xvzc/SpoofDPI"
  url "https://github.com/xvzc/SpoofDPI/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "28c11f40cebe4ecbc7f27a7909b37b8ce8955a116dbe98cd018664da1e41a76a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ae13195ad2bffe6749681fc37548908056f5c98388bf2a7a98f0e9043136e22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "797ef3629d67660384a71ab7ec243b678cb67a30fa90b80972370f97fc6dfae6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "004b0d3999b515dd3db337bfd1dba0cc181db6434e1d2ac89ecfb110bf0fd401"
    sha256 cellar: :any_skip_relocation, sonoma:        "be4a7a4399ba972c86baf1e1107895421dc193a1866655f472654301930981b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f08f46f89120b33e4c374410505961a5d3a27d0fc5e68d80049e566a25b91954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8c9008a433a1a6e09f9b6e8b00fb1ff0edf1d3317cb6caeda333780bfe85311"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
    pid = spawn bin/"spoofdpi", "-system-proxy=false", "-listen-port", port.to_s
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
