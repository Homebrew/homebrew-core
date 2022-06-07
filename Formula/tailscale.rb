class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.26.0",
      revision: "9fc6551b4e4ea7bb83f70222bbc844dae7d184d3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95086c73ae897d61b9dba43df591081ec9cde65d44bc9bd4a4d2d7fbf9c7d017"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b37eb1396c6cfd6322e23b105c449842d8e18906836e8177a80c37250fd33f75"
    sha256 cellar: :any_skip_relocation, monterey:       "683bc77860ef3a392bb2e7b0063aa5c720bd25303a8f9dfa39f7c9a1c4830c79"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccce1af10a41967b86c300c6a928ded2e0ebb426575e27caec60889a11774195"
    sha256 cellar: :any_skip_relocation, catalina:       "c5ce91f53a903a04d08fca67aae402e5087b2bd95d97ecf7a2e9939b2f619b10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "607cb2abf369745e958a2937ad561c348308ea0260bf9fa658c93a79db5d65b8"
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
