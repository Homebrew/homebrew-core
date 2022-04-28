class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.24.1",
      revision: "759a2bd5465fa138ff381e445d3b59f0b3f0286e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbc5395f9785bd382b0c8c103cb8e14e0b088fb93cb05e37f144a9e5e23eb48c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54a8c89246d610b184c6d9934efe24894ecea04b3748a85ca8125099c5f98658"
    sha256 cellar: :any_skip_relocation, monterey:       "bf4d188d20ac2ac660241e6861ac7476bbbf7429018b51689272238ba6221a56"
    sha256 cellar: :any_skip_relocation, big_sur:        "f87e344736bb9daa5296e295a0c910f1f2eb1780415c94ed2c9d5f1b34bb0737"
    sha256 cellar: :any_skip_relocation, catalina:       "a541879f4842d6a39517c63ad830409fc602fb92e38ba305f46878febd40ecfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "562d119820a381d8a38ef9d06925dcf946196b5762a36728d8242b2a8ee822ea"
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
