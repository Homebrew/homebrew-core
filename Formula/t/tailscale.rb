class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.98.8",
      revision: "05a91829316e055517a1e84f7b00016846ef4107"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf47b49de5ee0f9636c1bd8b8e3c3baf2ed8580b5b5bcf470edf5d3da6efff48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19b5233ad08005a062f8fab228fa1620a463c4e2b1b9b0a3258dcf8679b2e857"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13f98869370ed0e85534048182a616cbff6ce966d93e4af267046b4737ea1721"
    sha256 cellar: :any_skip_relocation, sonoma:        "2587e7d640709a37f97295678fca5cea9f4a51254b4115d0e3e258ac6cb22ee1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10c57dc25a512766bcf5f909ae20377814af053229ac63d2beaef9e5c45ab3a8"
    sha256 cellar: :any,                 x86_64_linux:  "5bc870317821e59c871694ab529b660c164bfedb733c88740e0f8c291d8e82ce"
  end

  depends_on "go" => :build

  conflicts_with cask: "tailscale-app"

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

    generate_completions_from_executable(bin/"tailscale", shell_parameter_format: :cobra)
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

    spawn bin/"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}/tailscaled.socket"
    sleep 2
    assert_match "Logged out.", shell_output("#{bin}/tailscale --socket=#{testpath}/tailscaled.socket status", 1)
  end
end
