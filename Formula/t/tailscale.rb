class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.62.0",
      revision: "cc950c079140abfdaaf69777fa171f0bcfa63598"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cefeb1860e415cbd56b2b4a6be4e95222e8480ef0013d87f3e49bbcfe266ffa9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55a3e38f44db9861079e119ac801e2ec7ea1a745184496587f4cd09e090880b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00d7d547e155dd334e05dbb1fab8d38ea5c9eba548a6b21ddcba21417894e51e"
    sha256 cellar: :any_skip_relocation, sonoma:         "56e57d7a7c44ab8f5c3f0c3ef09a952dbe32dc480dd4e9dcddacdd8cab1ca997"
    sha256 cellar: :any_skip_relocation, ventura:        "98c60d374c527d54ca6d161d03e935d195e7ace2d5fa8b0aa4798998eb9d1117"
    sha256 cellar: :any_skip_relocation, monterey:       "d948e8cf48fd4c51656287752b6a5c4c736432f22ef49da06b7edbc5bfef5c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b1b16402b9936029f42e79a4bb1a0315abc4d6c555a46ad3a813c449f944e3e"
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
