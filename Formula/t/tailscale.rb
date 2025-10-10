class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.88.3",
      revision: "9961c097b1781891e3c6b96e5e1194355ff06a6d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30f0d3181fd6440fd69b81595923e4bb830c8563f9cc4f3242d970a7e62fa159"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56ba46922dfcc018a12bcb47dbe27120707da564182226ed3514edc70dd77bb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbe0a9d1e0357b008a6ba9a8ff97c0df4f992354a2d2f67023357aa10f04c785"
    sha256 cellar: :any_skip_relocation, sonoma:        "19a03fc7d5fdf5f437a903d7227ecf84931b4593554e764209730107a2082e63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "522a7cdd484b4aa3864dd302b79b0445d32bd0bb4592a678ff3b73c6082b87fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12bf27b8cab2b93a16374e9628ce8c920431ba6b0a76a200d3f28bcaca89f112"
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
