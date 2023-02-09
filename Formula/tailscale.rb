class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.36.1",
      revision: "576b08e5ee7cfd1ef052f44c4b2f72c62f965050"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "203ed6d28eeb29a34084c34ac513f8104d260df01b854098b3b41dc7cdfa579f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d17d18a25c5ea85c8e8acab50544c2af8207c5b22fe956ddd7e4a544753df7c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6569488554d7058ec5598613793c6aa5cf8df4e89e49a8008bf8dd597f42dac1"
    sha256 cellar: :any_skip_relocation, ventura:        "2efebdf142e7f1729bfa31c6c7695969cff1ead52450759e082ae94bf001981b"
    sha256 cellar: :any_skip_relocation, monterey:       "28624f20f0ccf1e0be6b75527130aa8a249a840dc7a479748764edc1930ce72a"
    sha256 cellar: :any_skip_relocation, big_sur:        "01e4e22f362eaabc2ba1a88ab56d3b49998891b42c57cd3d5435c26899bd1bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d43c83a4a3d347a54ace9cc008bf7bfecc8be8b82601aae6935ee789b72c678"
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
