class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.76.0",
      revision: "51fb4ce51753b03f79103bc48b798b4d13f0be6b"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7497358133070c67a4aaadca7987b145bc1c9821d01d471216a9856eddc564de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "535a8388762342ec1bde31c80a275241533928e915395516b597c651305d2f4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10051125af37d362f14cee158ec4a28d9591aa6925fbe5c7b43945eb92ac3bb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "938483fd3e52ae50ae6dcaa59d48698786dc684364070251ca70523b347dba70"
    sha256 cellar: :any_skip_relocation, ventura:       "42e414c22d8896e06dda28c57d99da56b0fed8d00411d36eb22fa50dd27b699e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c51d30f8a988c39df04b9bdf1860999e829057e5bbaaf102f5ddf5a13d4d7d80"
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
