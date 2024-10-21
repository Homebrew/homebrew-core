class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.76.3",
      revision: "02acaa00eebb5146f7d41885aa3ed190cc107df6"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6679f695c9c01ad7c29b9ea3e1f8199263c98e5cd11caf12122bcd52256c22c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f8e615c5b700c6eb25d10f019f7433a31a19fa5d5069b4198d648058cec287b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18e645614b3648ad9a6d56aac9fa4d396d90478fc7086dfd5bdc0f5f70fb6265"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd43195a827731b4055d073208e3f28fd8a1d5a4b10899e64fb2737d1bc5a3da"
    sha256 cellar: :any_skip_relocation, ventura:       "0bd4e21544f0b030df279f6b1ce3744cb0e83885172d3a2063026e225b4ad834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "458a2d35b2faf62c4dc171ca23cf24d82f80ec5892b7b2ab964a8ce60c621087"
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
