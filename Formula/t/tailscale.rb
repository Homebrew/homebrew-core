class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.64.2",
      revision: "ede81e2669bc01d60f52c84eea1d404215b13e16"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1bf2ed37660279253164a0f31cfb3e7f8dafdec22bf194c02b37a2ce714fa884"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eebf1e5271098db2f3499e33fa2bc7479229632814b1950f2d1df1a5f5a4f11b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7939853815cbbed23e587a7bd82bf7ec41b9cdaaf22b2a1ca134e734cf0ffdf"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5238126cb10c2c75fe503cf8ec750f06ffade4ac551af843aec3cda8f30606b"
    sha256 cellar: :any_skip_relocation, ventura:        "257cfe1918cc8955147f4c55c8143b28a934a7c5ffd92b70d27aabb6f272b1da"
    sha256 cellar: :any_skip_relocation, monterey:       "2d7955be29022033afb249d941a8aba54e93f3484fbbf5ea05bb73dc4ece1dfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96fe0f20123402da99e5d74b224b5550afcb945f07d79b5939b1bdfe903105a8"
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
