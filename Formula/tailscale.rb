class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.24.2",
      revision: "dce2409b15837f30885405b8b1d27e7b7fd6bf7a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d93a2e9efe02e8e9a4b4a99185e474056f206b88f0a36242ab788f4e571e18f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e402bb9711ea0004f15aed18697eed92e43fee50d7f677c8bb71e3a7eed6c72"
    sha256 cellar: :any_skip_relocation, monterey:       "f25dd2737377b42ad1fd36001d41e0055db37e04734d7ce634c323ceaa0bc30f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc94d7d2b0ef9b42754340aa286e397959874b5fec2abad611ddb0c75d08df27"
    sha256 cellar: :any_skip_relocation, catalina:       "d930c3b1ce43d954ba2f5fd8d850dbd3d77f242ffab490d3ebf0e8e8a526aef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a4d32cb637e2422b2a90d7f32aae2e19d4626e0591853d862a03c57e553e6f9"
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
