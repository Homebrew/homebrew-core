class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.48.0",
      revision: "77c732357bd891ff062b8aeeac5489f85315f261"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "373a98fef0a746d07aa41d6cf4f0e6ace63bc96b2e823793adff933467edfa6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e2b5a39f5e95ad44bdc6a19bdf09b237752e1100a16731873557fada56993b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff3aca82c7cf2ca7ebda38d9efad8bd13494ac7df29486b3d9143748286be58c"
    sha256 cellar: :any_skip_relocation, ventura:        "e06b138dcde82131f3489868bfdf29a5197ffcfb866e83dae34fe68257296159"
    sha256 cellar: :any_skip_relocation, monterey:       "e5e32b1700f79eabcfea6e5b5e07a5000757a306e787aa07660a2730919f31c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0f8562d597480a1fc0b1930be9801df9aaa07055df8630ae4b6442283156efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97c5fc7091306239157027ca8f4ee3b3053ba81b20103d8551344e9160291dbe"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tailscale"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"tailscaled"), "./cmd/tailscaled"
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
