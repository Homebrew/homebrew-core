class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.94.1",
      revision: "d885b34776cd2e96f1f368a4d31729e37ff8b59b"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89b7991f9aa226c4bc1e8920e1c626e7599af0dacb15d4849e818e61a3efead4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd4184c80c37011040d49693434fb6d05adb6f5b89525f2f5e25aaa79e9f7872"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c51ed0928285b11e5b8490961a061e4abd4a9ef84a5733f6cd1f04709198224"
    sha256 cellar: :any_skip_relocation, sonoma:        "c209c4ee26ded785b2893d9e8ec2745fca795b0a872228f64c79e62edbb85f1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a029c6d22022602d8e86f7f582d8deaf925a5be90daeacbb9eb2229a3d1a360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a0fc1d71206b6ace0526d9c2650abd9da7d139228aeca01a4ec8ed9531ff126"
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
