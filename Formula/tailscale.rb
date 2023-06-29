class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.44.0",
      revision: "b3138a71ad0b2fb7d99f0dcecc5e4bc85483bb4f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3d55db87bc3c8c20bad92c7fe9f581fc1649af11d5b53d25cd630e0c43d2055"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3d55db87bc3c8c20bad92c7fe9f581fc1649af11d5b53d25cd630e0c43d2055"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3d55db87bc3c8c20bad92c7fe9f581fc1649af11d5b53d25cd630e0c43d2055"
    sha256 cellar: :any_skip_relocation, ventura:        "31d7cbbcd573b566c3a2de7eb9176898340c99d9535e4499ca37220a9ddccc40"
    sha256 cellar: :any_skip_relocation, monterey:       "31d7cbbcd573b566c3a2de7eb9176898340c99d9535e4499ca37220a9ddccc40"
    sha256 cellar: :any_skip_relocation, big_sur:        "31d7cbbcd573b566c3a2de7eb9176898340c99d9535e4499ca37220a9ddccc40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34451133da961b9e7d7bc33dcf9a6e73b2409ca2aa752c8069d77c9ca2aad467"
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
