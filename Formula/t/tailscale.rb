class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.56.1",
      revision: "f1ea3161a2a06ad6474a9ea919e91e9bd6062f84"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18431e4b58195dac072c50f5a51e0444fea119dbe95644c313e622f0e90456a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f558acd652520d514fe520155289e36346b2eb26f2e37c93c981817f89a75ce2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e47d1531d2664661f65e1c4e0a207116e1e62b36c046dca8e1bc076f21482103"
    sha256 cellar: :any_skip_relocation, sonoma:         "251abb983908b74203af1a3def3c839ec8a3e0eeb67d5819c1805e0a31a1be99"
    sha256 cellar: :any_skip_relocation, ventura:        "fd6138a8c86b7ce783354182a8f39a3b1031c0576780ae677a5d9cdb31294dc6"
    sha256 cellar: :any_skip_relocation, monterey:       "5a5ca2cb923b6298dd8ac72ef20f0714e3a9936ba210db11b936dbc3131fe637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9cb7e6a241071925df399ab3f713a039869e2bb7bfbd41363992f3be57e758b"
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
