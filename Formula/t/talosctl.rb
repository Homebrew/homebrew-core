class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "358874864900c61384a80e779e156550e0f44a502eefbfd1326a12786a8d3b4d"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ab9dbc84922ec9941ecf80cb38513ccbf29ffae69a85bff404fd7bcba557561"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49949fa9b7995fa06ac07b38b9b1816366df376ed9964d47cf55af9c5e618739"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eaa3793f3c2530c59a555485c3f2f6cbdbd3192ca4e3cdef8f68a9971c19193"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f3f674eeac89233e4e4b00406c88ad2d1e9f67da16234b622595f3a1eb387d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a1207d8aaa90e3f676aa838a1acd295eb1db4ed62c9aac03753ac0d300cef59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84c6d7e11663eeaea3f7b35b6571d21bf2739b645e3c1e9c6bbb1e44c757fd42"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/siderolabs/talos/pkg/machinery/version.Tag=#{version}
      -X github.com/siderolabs/talos/pkg/machinery/version.Built=#{time.iso8601}

    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/talosctl"

    generate_completions_from_executable(bin/"talosctl", shell_parameter_format: :cobra)
  end

  test do
    # version check also failed with `failed to determine endpoints` for server config
    assert_match version.to_s, shell_output("#{bin}/talosctl version 2>&1", 1)

    output = shell_output("#{bin}/talosctl list 2>&1", 1)
    assert_match "error constructing client: failed to determine endpoints", output
  end
end
