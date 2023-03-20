class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.38.1",
      revision: "3eeff9e7f76748cc484a8d1f7f4faa71a793bddd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cab1a0d83a1ccaa6fdd8273d1d6e928975c4d5b9ebe1c6fd32b6fa5e37707b38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cab1a0d83a1ccaa6fdd8273d1d6e928975c4d5b9ebe1c6fd32b6fa5e37707b38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cab1a0d83a1ccaa6fdd8273d1d6e928975c4d5b9ebe1c6fd32b6fa5e37707b38"
    sha256 cellar: :any_skip_relocation, ventura:        "6b7201e2b8dacf4704d37e809e3c66f3db4991624563a7e4778ca4bcb0648a52"
    sha256 cellar: :any_skip_relocation, monterey:       "6b7201e2b8dacf4704d37e809e3c66f3db4991624563a7e4778ca4bcb0648a52"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b7201e2b8dacf4704d37e809e3c66f3db4991624563a7e4778ca4bcb0648a52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7e077bd216d421800f20c4371882f786c1578f35b4b5eff6259c40048bb21f4"
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
