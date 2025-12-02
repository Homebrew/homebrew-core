class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.90.9",
      revision: "66826a496b678495bfe70225b261288edcb26edf"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c7458d06e429e85c3d0609dd1ca098e572efa1a89ae6d975f1615c938d3ff3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cdf993672169a028395def8ff1bd10d0394da9f45ca43075da12f66fb645b06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7258d794662753a47bc040375e6a8d0c284668204f1de2a988ea79086c108880"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dad9844ee43d30b0b0278a4df76172446bafdc224685c8551e8974b86880646"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7619090ccce5f4bf8327f9c52bbcec8cafcfe56396059ab7052234e000386b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b6877a02fdde3f096dc53da2ff89d47bf85bd6579c634b0676b01631a1a29c8"
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
