class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.88.1",
      revision: "0d95d67a807222c4d5bf4fdcfc1a391683cc1501"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b54fc0b64ac51f856eaa516cfe3272785c161deb720221a76cc6c821837cd5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ee8da96d3193170bc52b8f4f1905cab487dc42b81e60cc1cefdabccb598d7a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0da581dafa3f327854ab31d440b612e8764328ca9a0f536bb4e5362289a80aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05eaf312790997d1a3a79127c48554f134568b9b4d8626bae81df840808f0675"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5621e872a2ad0e7afb532bdad8b3d8c3e5fc3172e62189b7f3722a6f6a10ac2"
    sha256 cellar: :any_skip_relocation, ventura:       "d2dfd0016c88264b908ce9f36eb7e507c3be99c78dc477760bfcb78193f47286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7524897a09ba7f15c5b8362b2e9d0a8c6ef13cce2cb0586396935b03fc8e27a3"
  end

  depends_on "go" => :build

  conflicts_with cask: "tailscale-app"

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
