class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.12.6.tar.gz"
  sha256 "bfae01fe1db88cadde1502c552f5bae673524f4dc3512fd99e001c85a86b4515"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5160a17ee9f3abd2406a459e4a7c264c5173c78fc6cd0d2abccecd11029cba69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c02405c82994a4a3a2bcbdc4543ba6bf06b5cbe8330e1a3ec039ec54290826ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b2dd9369a0ea35c4752e1254d958872240438b9a3b50ffe689e03c91a78a4a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "124ee26338badd95e3c18e9831f8eed0bd2100e7d05748e9e158da186881aaff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4919eee7e61728a48895fd835213e5865676f0711edb6f75b12b3a16469f689"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4912fd07a178e7d5be02b50a6fcfa215bbc79d00f748ae1e618f8016ac047b76"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/siderolabs/talos/pkg/machinery/version.Tag=#{version}
      -X github.com/siderolabs/talos/pkg/machinery/version.Built=#{time.iso8601}

    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/talosctl"

    generate_completions_from_executable(bin/"talosctl", "completion")
  end

  test do
    # version check also failed with `failed to determine endpoints` for server config
    assert_match version.to_s, shell_output("#{bin}/talosctl version 2>&1", 1)

    output = shell_output("#{bin}/talosctl list 2>&1", 1)
    assert_match "error constructing client: failed to determine endpoints", output
  end
end
