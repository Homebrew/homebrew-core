class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.14.7.tar.gz"
  sha256 "e27a9541d19d6276c6beb82f7af9cf8638fd40105da04ea8dbbf15a707ad9a35"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "cf378946e22ae25d44e695ecd1934d70f1264d606d9dbb3c920f228cf4786d2c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cf862f8618139b78356cf612fd16d5d3cb8ca0d1337c8415b23936fbeb803628"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aa48d1194975c6a437d865db05b75f2c23f0542d0b155fd5d2156701fd292a5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e645eda9fb7ddd785f52dd26283b712d5d18b667001fa13de747010c024edec1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e2fdd7cfda97caf07a82bcfd74cb87a4bbe81a26f1dff5329ddc8fa652356ed8"
    sha256 cellar: :any,                 x86_64_linux:      "7942c613a6b84e54619901d9c7899056fa15c3d2721a7f15fcfbbabc2d5c2cf9"
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
