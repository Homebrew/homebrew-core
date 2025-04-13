class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.82.4",
      revision: "97f368a051453289881268cfefca8a98ae761810"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a29301e365a913ad16d0ed7e52b2926e45e732c7a01fa9e26b7dbafd10fe6ece"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6d4d4886fd0d29d7e245e6ebedf6fbbc9e5d11c1cadffa3e37cdc420bfb87bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "103db3f52ee3e745a65389f8e428b3e94314e6373f9239ae023b936be32784d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0599de6ac4a58aa0a7dc0d2489b5acaa6b57dc87d2516501e58e91ecd143ccf4"
    sha256 cellar: :any_skip_relocation, ventura:       "e3bd6b96ce61a16581e03cd20053ebffd82d33f7d257d3f11337822a667c446a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92e0888f5b90664dc0581c0465bf3c8fc1cdcda8c5ef9c84d6fadc166fedebe4"
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
