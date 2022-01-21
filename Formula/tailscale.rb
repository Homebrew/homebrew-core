class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.20.2",
      revision: "8e643357dc806ad10adbd833abbc5181c99ce305"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c00d01c661f5edf8e52cf2979ac81935b7d137cf1ce4be08c7f31f8720579024"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eafad19d8d932dbd17312170585fb4e90e34f6d7aae3e6a9df8c1b3f55e785f3"
    sha256 cellar: :any_skip_relocation, monterey:       "60544d82cde8d1f795f3a3e6f64aa8ba26f3a90ea59bf08b618827688ae56e4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "88b61fac2e1f48b6142949ad5098b8e3da7ee10bf0946a1b8644bf100c222712"
    sha256 cellar: :any_skip_relocation, catalina:       "dfd21594a1add6132c4a5df540b3702dfd3b65acbca9b7eb98a11aab3bfcd186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "450c46c746e160190e2234b4fdccfa961695a2ab222e893bef19d204718a32bb"
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
