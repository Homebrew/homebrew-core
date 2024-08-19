class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.70.0",
      revision: "d601f16e1b676b11902ee5d71e6042d95fb09252"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6f82fd92d6cb4ade2a8f50795ad9c958fa4e2e77b249a4bfb57aa055f742641"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73b42b4f2e1be5b8b90d7a6a11d8252de280dea02bd6ccbbe7434f58f6a1f5d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c9c06e2c9a346172ace891e949f1a86b8f4467d43ad09b0098cf80ee723dcbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "f19362fe714144e6ec9c412c4f4ac99fcd328956126228c79d34c1eb48931044"
    sha256 cellar: :any_skip_relocation, ventura:        "e96f69d905a238139ae9dcf0ca581e93c5998d21f6990e82917d124582bec295"
    sha256 cellar: :any_skip_relocation, monterey:       "4ddef8c61411f57684bfc41df19f9a6f02451a078aa7a746183e3a0d1d6985cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b473f166322299648508b19d994fa4eefb45e5752b659941e226188de48193b5"
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
