class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.60.0",
      revision: "f4e3ee53ea4605d400df2ef6b6005b026661f96b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bea2cb1a514af0d96ef62bd476fc68aa472a6f7d58c368fb3b9e8991ba82f073"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7713e27f481e0f848367579c5d75d52d7f782fdb821fcb048196b7190805cfd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84dae10c3a1432a0354464fce0c62342d94db840b7b11842493d62c596940782"
    sha256 cellar: :any_skip_relocation, sonoma:         "c11d018162bec5cab30d637f8410c79e2b72644cd81b949a7dbcc337a0f7f456"
    sha256 cellar: :any_skip_relocation, ventura:        "4d6cf89eff80603fc358680920b762baf4bd8f910a34bea8e03aaac360f772aa"
    sha256 cellar: :any_skip_relocation, monterey:       "531e277ff1705c76ae513c387fafe225654e8fc02569fda6e4a0ce8c7695f3b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05d5ec85d0f770f0055778f80aa7fd674bc98246e4bfe1b492fa7b547354a316"
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
