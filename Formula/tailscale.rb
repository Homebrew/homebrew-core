class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.22.1",
      revision: "c8fb4f8c79259ae22e4ddeca2e6f72a832e07a47"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "485dd9706a76b0cc707888f7a9c5656e8d1ca6d960360eb85a4c69c3c6a6c455"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fbc8e98f0bfc5387c2f0c64aac108f418b98af1d3b84f1091fca614d190576b"
    sha256 cellar: :any_skip_relocation, monterey:       "b9c00597e565da0e10ab2a8f5a54216cb0c3855833592c5aa82fae0b037ac870"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9d7e6b8711f523cbbcb6ca85640ad88d6c54e2af596f158e37815ae908ded47"
    sha256 cellar: :any_skip_relocation, catalina:       "c98f158c5dc02e31737b8e657e5a1e217a6e8bb5f87adf5d366a7fa6d9939f0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6781799230fb387872bcb5a5e66716c00dd8a395829650e3e5c08ff747e3962"
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
