class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.90.8",
      revision: "ccf4f3c7ce53f977d7bffc80734a927964a0a890"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b1702733818eb3534e393c7edf2d193ab09e85e631b221d6f74973370ff0888"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0de448b3e6a9bea83f9733bfc757429927dafb6efb61dc615776f7c8eda7cc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ed8a5ce6b3e782637d81d99efdd29a656fde6e71efd94d749ffd6991c86039f"
    sha256 cellar: :any_skip_relocation, sonoma:        "be1e1e13e1ac4af009b3cb3dba6ae8abbb99c19e66aa13a825d82452e7855776"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c5b92832fc82e114145045891077828ebbc5c5ad36ac259c71cfd38fbdd9a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e34987044b09ad324ce3b2e07146a707c1e4cd34c03f309be7cbf31f09bc3a57"
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

    generate_completions_from_executable(bin/"tailscale", "completion")
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
