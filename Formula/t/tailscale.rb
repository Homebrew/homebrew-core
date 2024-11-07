class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.76.6",
      revision: "1edcf9d466ceafedd2816db1a24d5ba4b0b18a5b"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfc39277b7f8b339763ec26e204277c72dfbc03c924726f2386fa0de57567c20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "691d2e54014ce2b906e003c786bf72a43e917f3aee7423bd8a5bdd2bf90378e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9ce6f157848c7745431b7c026527713f4821385e26b2a51f2f66434856dd6d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "36a2e9c9ec644cfbd28702c99c6ee17fde3311cf7ddbfe7c19282a85c2713bf9"
    sha256 cellar: :any_skip_relocation, ventura:       "d51a7d92bd5c80f116983e1846c59dfba5cc1851860c5f90b6ef032719395748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26ceb20fe440aefb28328f7f307eedf62a7d1bccc2dd830b330ea9f078f6275a"
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
