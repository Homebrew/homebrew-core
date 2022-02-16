class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.20.4",
      revision: "8e32002cf32c03682a5156f2f9020b088a5dde7f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cf41d8dbc1b29d14f85f17c0323abc2b8f072d4ac6f26c7a49f3af57578d2f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8839aa5cb07c08cb7e7682bd1c44f3f2412b33e51a54569222be1117d710e31f"
    sha256 cellar: :any_skip_relocation, monterey:       "22c7dc16d1a92cdb45cb1974b6de4208726bccbc60054e7cfcffd401648e052a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ef8498798172e2326be03b92ac7bd1d7c3cea4ed4af38652a11db135c49ad7a"
    sha256 cellar: :any_skip_relocation, catalina:       "b6c9f280c22300b590b25141c70c50453fa23ec88446f0db31a3d10e9d968931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c012eab7a35c5bddb1a346db56d9a484896491a102cd4e175502bf14623a719"
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
