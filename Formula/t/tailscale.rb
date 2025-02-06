class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.80.0",
      revision: "649a71f8acaad5b91f9cd5a4c1fa164c780bac7e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c23e251854da2fef6258cb17d3aba67869fefc8cdf14d0b9430ab1028a245253"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24e797ea779c8f36bd056c179fd4b868bd6703f4541d6ad8713925b4a991520a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5513dd824ba10f21883801cfee254d7a9ccb3a4d84b7634087275aa6b2a9212"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a94cade7cb2f08e70c8fc4953ac95d40f60c921ea3e193fb612c000863bcc9a"
    sha256 cellar: :any_skip_relocation, ventura:       "2248230d708d85dccf2bde4f154f761107c5ee4cadbf5e80050cc83308c315de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf355eac26ca6f806fc355e122cf078e1962be91242c38c60ae748b2a3d35028"
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
