class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.26.1",
      revision: "5b81baa7d367d353707e87e0f9a8062cccc27c1b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7dd7184a0b9cdda568fc5dd5b41b2daf3a1042f08c768dfe000c13bdab5cf3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e641d9ccddf9d70a8a4043ac85b142c30b5b335967d23bff20355b56c74a18a"
    sha256 cellar: :any_skip_relocation, monterey:       "0fc894500f25b5ee4c9b3e60e36eadae2cb3f09e31c47804db3990ccd5843107"
    sha256 cellar: :any_skip_relocation, big_sur:        "92407e682aaabc36b2a89fccfb32bdec3132a9d0f1dfd507bd924d6f037f375e"
    sha256 cellar: :any_skip_relocation, catalina:       "44007b40fbb71265d686e19e4ce22feb2870a46c98871167282451ba4bc06353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc27e4a665a6885eb4c3cc9216e2fd766ac6b52e049640043a9b5cf7beca93f8"
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
