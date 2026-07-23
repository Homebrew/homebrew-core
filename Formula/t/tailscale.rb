class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.98.9",
      revision: "6c167d40fa37aeb51afa7ff336730670ea4762bf"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a06eab575773d493b06e20727b1b1ebdfb78e5f46b86cdbf0af97c8b09c47f2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c660e901cc026c8f4e2b462da067b6e9ed93aad82bb0e3544b2e4bc4f714009f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "824fcab82d64fb435847df27d73ab28fa581307d08057feaa0e4131bcb7bec5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c89a508456b9cca084e1a778f0fa0f770c59385f3b53624f11203c443b4c5781"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d558d4a7bfd2f79e4b7610ef1d6355975b6cc7d2eb42eae345a93877a9f3f282"
    sha256 cellar: :any,                 x86_64_linux:  "cf7996f1d796e50236faecba9e24a2872660e0c5cf466f97bf52b8ff80938a8a"
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
