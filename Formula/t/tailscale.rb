class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.50.1",
      revision: "8749388061d0251483389fa876afa01e0e76f15b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f6de3650d89e04c29bc7887f874729ac4f72291e86d74a1ff7d8374b2e8df29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0310ec55952625c093bd0f99b859afaa5ae77dadb7507a948bfda5fc9916acce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ab0d23acc8f080aff7f09040839d34776152143c7c711d427ac770e0a1e654a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d0b5f081fd0136ea7d8953fa5521b4b27b67190cccf75f602fd6e7c751a9d78"
    sha256 cellar: :any_skip_relocation, ventura:        "d0cdba7b4695de914ccf79cb51eefefc0630ce83ea12e4f80b1369ac81949361"
    sha256 cellar: :any_skip_relocation, monterey:       "ed76796dc08ead9050479543ad4f41291877b41c67ea6dde305acb908fa01f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4544cbcd884776368115b57180133d4efbb02b4efe8831ae1dbabb654a11ed36"
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
