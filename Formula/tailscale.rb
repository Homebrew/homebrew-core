class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.28.0",
      revision: "aabca3a4c431d24199c1deb25d4684516ead88ca"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6331bff437dcd5b3755d1461def9204f7c45edf14bb155c5a8170d4a9932aa0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3957d5624e89e45840f996c6b922b15423ce64e10d17e37283b80db5479d335"
    sha256 cellar: :any_skip_relocation, monterey:       "f283a3b9c52d535217be4b73bbb5a2e1fa5e3415a53a7d1c4b6a5967b0b0002a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f92a30787902846adfb6101c379c011b50e96045f1591d29da590038ee77eda"
    sha256 cellar: :any_skip_relocation, catalina:       "233478785e4e11dbe4af14040aa875489439d3630f1bf9fd54c7b26475e9c296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9110cd462341af55ec8bd27987fa23d9240d1c57bae86cd7e917a26424baa1f6"
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
