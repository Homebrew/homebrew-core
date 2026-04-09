class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.96.4",
      revision: "41cb72f27119f95b859335f3ffc3434d6ca55e23"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a29fba8f8870e8003b6fa435d1cad8ef830d612939465caa25d096eb918d1950"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "116f5c3948f0d8214c22dc6682a2e1171dc9e3adb2e05e3b9e9910925d7f0839"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b59244df8a725ccfde1219124520af87a483078b8b3f8f20a51187e3954a549"
    sha256 cellar: :any_skip_relocation, sonoma:        "5199e1b7dac4ad8e8a00df193624d38329f8a2c04136e5deeec0e94371463946"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddfc91bd76970b812780dccaa8bf5ec16318069e2ea159b0edf322e33402d24c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dfd5298b0d76401d29ac9e6b90b648380f890a422ed761c37f49b9611ea7bda"
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
