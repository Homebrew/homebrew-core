class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.12.7.tar.gz"
  sha256 "e32baf04be95f2ebf1b8f1a32a1dcf972c106038b9ea94de890627ecf1219d9f"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e83bde6be16dd6f7f1294bf86140eb07a25bf407cbfe2292a39201294a9042e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "477a994f9af1c0600b8bf4ae36afb058518a8e2f6107eef87788234256cb2520"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8759d06d51a081a71e3b19dd844555e1a0bdf4bdd63f8a6632e98954cec89e61"
    sha256 cellar: :any_skip_relocation, sonoma:        "de1a4efbce9a046e7a5d3d613c1c7041b3e65c1925335607c26e87eedf89f6b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06667ebaef72f5760bbfa26958c72b20d3afab5cb4693fa843bd4a466c4ea974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a1bed366272155b2db7cb50f207c23a1ab2317540db5e20e225c3d53ece3679"
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
