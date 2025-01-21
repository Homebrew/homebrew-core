class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "ef9855bbdf9ded1de86e9851e798b108392f9a71d1e2702236a7787aeb04bede"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5da37cf842daf93ac52a80c5d4b07c5df509fc7ab6fdb569523d9669c743facd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "720c6e9350c14b765728bdd3f8af35bd6b797715d8ff5747e7c7d1dae164ea1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3def772811e59d7f5a08c631e6d0d635620c2d653f99fe6a1fa30c893c94fd1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "02d17dab63f71d42c5dbfacd06c4779c6e7129fa1692601b35509acbf2320f52"
    sha256 cellar: :any_skip_relocation, ventura:       "4b4396c92e6ae66a96dad442bceab01f77aa8b0b63a5318962bca3da02cee8e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75d4cdf52100a28bab6489e178a66658ad6c544513d846fb4a0702d7d7903848"
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
