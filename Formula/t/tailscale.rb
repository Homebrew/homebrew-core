class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.62.1",
      revision: "2827330c6adacd9a67940621b5f05b589527c550"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eed446c7545446400f5630e66a0a8e72dd700e08eaa3dac730ceae783ff5bce0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29596d9d789294b82aba9ceb50b4cc8b21bc8a66652f227a348260143e45d0b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6027f8e66a9c8da5aabdc80c5d6deac606379ed650fa5e7516f4e155c09f600"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8617519e9e71a208103d8f51d7226867a4e79c306624bf557729c1c4cebc3b6"
    sha256 cellar: :any_skip_relocation, ventura:        "7a548483867c97c04847c01f2e4fd419c6ee1b5ac4f7f8574844091328a913c3"
    sha256 cellar: :any_skip_relocation, monterey:       "bd842ca1b2cec3c0d2a70c0499a16130b9aaff18b4392b14a2042969fd8e1c34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb290453f5e6d98c3f508c9f97fe77b1da8c2c6ec8b4951d1bdf8aae39af748c"
  end

  depends_on "go" => :build

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.longStamp=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.shortStamp=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.gitCommitStamp=#{vars.match(/VERSION_GIT_HASH="(.*)"/)[1]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tailscale"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tailscaled"), "./cmd/tailscaled"
  end

  service do
    run opt_bin/"tailscaled"
    keep_alive true
    log_path var/"log/tailscaled.log"
    error_log_path var/"log/tailscaled.log"
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
