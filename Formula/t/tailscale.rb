class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.48.1",
      revision: "0e9f04c83c38eefac6bf55657184f22d11d777b9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "208a58686502bd7791f293814f348e82edfad420641cfb8061bded4597900432"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad33b71fed5758d6381adf248c9f8ca279c070bcc43ac6e6bffe7b7dfc41d24e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1715fe4d40dfe5353599ae3f0b4f36509523f422102e4981cf7713912b2f38c6"
    sha256 cellar: :any_skip_relocation, ventura:        "d41f907b0db28057a0d79bdda4dd93d7000f927125a9fe85f1f3f938b304ee12"
    sha256 cellar: :any_skip_relocation, monterey:       "41e77c5a0c2b0f0d8107f2b5df2aa1269f4b5247ee71ea09b7de8f2d780592f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7b2cafcfdd5245ae5dd9fdacdb831a766d9387890c1c92199841b5ff4997cf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "646151f8b1d19c116c398fc55562cf5d47801c5e5bc35655ff497e624e7b6907"
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
