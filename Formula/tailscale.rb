class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.22.2",
      revision: "6f700925cef22d8b2a100840c8d9eb084dadfece"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "096ba11924c19a231907259b2386db8f803b30c8f74c6375b2d6e701c908c91c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cae3283a8e216dbc95dfff42d344e88d7e3d79f3de51a4a4738da5b4e30a362a"
    sha256 cellar: :any_skip_relocation, monterey:       "81491dbd8d5d8ffcabd783b8688d63f102ab9aacb607dfcccc027e9e66a811dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "c249c52184ee41a070bc980eda23d61101f4a04a5631620a0e7687084f4bf39f"
    sha256 cellar: :any_skip_relocation, catalina:       "a2298b0e81ede629d8439b80e589da8271aebd8f8810e301e1ddee3b1807d91b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ba1c650d861a5da3f6a962d24a537b135a935a2ff2d075f5ab956fb9f679afe"
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
