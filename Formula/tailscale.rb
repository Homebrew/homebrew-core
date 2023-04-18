class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.38.4",
      revision: "043a34500dd2bb07c34e3b28a56cdbc8b5434454"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c4dd3394bddd0805e7d4002e94e09c8ab613feb296a5c4d39be182f16ba9f4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c4dd3394bddd0805e7d4002e94e09c8ab613feb296a5c4d39be182f16ba9f4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c4dd3394bddd0805e7d4002e94e09c8ab613feb296a5c4d39be182f16ba9f4d"
    sha256 cellar: :any_skip_relocation, ventura:        "06af1907dc0d0c15781f4853f01712c0436a871b1010e4a3506d8ae507f202e3"
    sha256 cellar: :any_skip_relocation, monterey:       "06af1907dc0d0c15781f4853f01712c0436a871b1010e4a3506d8ae507f202e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "06af1907dc0d0c15781f4853f01712c0436a871b1010e4a3506d8ae507f202e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c952507513880f0d5e0c2c67e556465e8d754c1198f01276bcd73f5113e122a4"
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
