class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "7e1b54db4f08b00ba07e273fac08ae708f53a230b4dd0868343f08c120f93b6f"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d209848443d9537433016eebbdf1ce22e22825e17fda98fcf669149ae57b2ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1473dffb355f90a7dd1d6d97b8919ace17f4be0f6e6c6eb9a4bf9544cdfaacf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1d0f4f75beb980995206162d1e296c9d57c6ee5d3de78ade167fa2cf5432bc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "480c6c3cda8a63bc95b08a3a3843064e2d373de714fda6c7dfdd372e1684541d"
    sha256 cellar: :any_skip_relocation, ventura:       "c566e2c0270921e1b5a43736edefb9b34eb8ea3ae67530d1af5f8cb1c9fb4d1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7480ca26d115cc259ecd85be308580ff215d95cb2ed779ab84b1044becb3baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d12645871af8f3a1cb8e491d31a0fcbe84c1b0c732b943d593f9b3460c784be"
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
