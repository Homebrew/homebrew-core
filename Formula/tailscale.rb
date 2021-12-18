class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.18.2",
      revision: "b04815c9cdee8b3117b2578f39689aba60f06611"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f364e01d3e582fb5ad460955d39fec2a59e4c904edf15a419b3dbfdd5a426b08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7846484f4b98434d173fdbd02525f8f38f9033a752f01137d26b8f48a1cda02"
    sha256 cellar: :any_skip_relocation, monterey:       "da2be8577bda01752e0fa0d763a7de2d9579e5264d51508502ed0c0d6ee9b509"
    sha256 cellar: :any_skip_relocation, big_sur:        "38a1d6eaa715ac99004063a3e30e12b759f77d5fc0669306d508c048846a4874"
    sha256 cellar: :any_skip_relocation, catalina:       "ff0bea0b9f2caf278b229758314fb6967d8e1f789fc8489a16b11ef6a8205c2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27ac19979c83e31fb77e7a3323599adc16c937700ecfe574212452e8560ffb67"
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
