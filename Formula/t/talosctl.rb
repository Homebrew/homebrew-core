class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.14.6.tar.gz"
  sha256 "7c52caa465e64e04c124be7a7580d34cd7d0ab7a4a257b6785cfc2bb1d626380"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2411efbf5a580304e528385c82702d87fb6aef3bb897725c1c27df19df5d8f75"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b019778697850b2cecace0f681fef3951fce39542d5d6beaf9672fc49b115fd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "00c0095aa61327fcd8ad28acc55162badd3452feb3bfc16407ccf39630450d92"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ca21a3d2778c01d03cd9bd099d90543183ab2b14eceec2462b6509e74db338da"
    sha256 cellar: :any,                 x86_64_linux:      "d7ccce85651111ba21ad9d853d462f77b07256100c233bf103259aaac81ce121"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
    assert_match "failed to determine endpoints", output
  end
end
