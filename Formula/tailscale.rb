class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.26.0",
      revision: "9fc6551b4e4ea7bb83f70222bbc844dae7d184d3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "304a865229281c6aeac6dd5fbb8f738cf8e3ea63e210b3712fb0d3dc8eafa645"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0479d0262bc08daf710dbfaf2cec585ff5145fc56f5678acb7237bf4b2ab34fc"
    sha256 cellar: :any_skip_relocation, monterey:       "9ef727e23b6d19d62e19bf2fb982e80cd3908c60be75c6f0652ac8a29bfb25b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cfc9d3d908a2260ebae6442b911850482816447b0d50765ddd66dc5f4548de3"
    sha256 cellar: :any_skip_relocation, catalina:       "8a8678b57e7e6951dd31f87724632125fde1928d056c5e5765d4a383787e77c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43c783ba944407c1eadd9f19317222b8eabab6b866cd25f86f7a68b0cf275022"
  end

  depends_on "go" => :build

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.Long=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.Short=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.GitCommit=#{vars.match(/VERSION_GIT_HASH="(.*)-dirty"/)[1]}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "tailscale.com/cmd/tailscale"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tailscaled", "tailscale.com/cmd/tailscaled"
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
