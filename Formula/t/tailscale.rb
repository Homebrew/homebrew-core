class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.78.3",
      revision: "1b41fdeddb6598b35ba15cc6b07740e0cc0e8411"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2775ccbf953176caa175e23be2092ec6ebd996847b72792c35993f95907d936b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81fec4905d01f2ca8645b2a7b43f9d2f8dc257282f3e92ee5888f586bb55f941"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5eb91e0fe05c342cd99edf659a94db6328396e1cb84c98bae20a03b3c89eb0fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "12b4ceb3815109dc6efc66ed79a8757106a5664674a54900af56dbaa55f60026"
    sha256 cellar: :any_skip_relocation, ventura:       "1b9311b3db6f5416b6a2b199a2289fc62ad14be5872779bcce44fd47802e5102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3f0874251e0ad246997f54dbfd1104406c810ac6a199f3ff7d423975c46343f"
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

    generate_completions_from_executable(bin/"tailscale", "completion")
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
