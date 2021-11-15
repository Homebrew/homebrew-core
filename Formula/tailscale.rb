class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.16.2",
      revision: "b56ba20549aedc0e56d09dca2552ca62421b2cbd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6369ec8c1be3895d5b75fad2cc57f8c3697fdb3c449f85db4deecb1b7a7b4638"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7eb3571b40b67a09646e84f9850fd7202d4775431c4cc565cdeaf1bf3e366c77"
    sha256 cellar: :any_skip_relocation, monterey:       "47dec5a678ae017dfc18fccba585d7a1ef27f8be473272ac8c9db4e78e359bb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c774d9e625e4637a1499a0d5ac2039d3af8526992fab54b6783304f85d4ed20"
    sha256 cellar: :any_skip_relocation, catalina:       "c04ee49e60edf8d7a6a0c0b80b8ad488b16d77b67307dd2982a540841b93e77d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49a5f97e4a3d980c10bfc98c98c1399cf67215faeff9af267ff42930fe13995c"
  end

  depends_on "go" => :build

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.Long=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.Short=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.GitCommit=#{vars.match(/VERSION_GIT_HASH="(.*)-dirty"/)[1]}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "tailscale.com/cmd/tailscale"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tailscaled", "tailscale.com/cmd/tailscaled"
  end

  test do
    version_text = shell_output("#{bin}/tailscale version")
    assert_match version.to_s, version_text
    assert_match(/commit: [a-f0-9]{40}/, version_text)

    fork do
      system bin/"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}/tailscaled.socket"
    end

    sleep 2
    assert_match "Logged out.", shell_output("#{bin}/tailscale --socket=#{testpath}/tailscaled.socket status", 1)
  end
end
