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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ac8c1beaa47d4837d4a666f30d8bd615d9fed5423fcd62f1f1520d2e906fb62d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "76d250dff24c66ef4a767dfc051d362abbff43cd40e9d1774111904139c32b87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0ffbc2cecc8b6e8c170ecd9b70f5cdc75db3ead71efe92c73e69c74782cfd2b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "edb5bbcbcb348a988a9bcad3be080f932f09fed4b792e9239838093e54140754"
    sha256 cellar: :any,                 x86_64_linux:      "55961574b4945f4add07737d3886673a959a80bc783d7d9911849e8407361f80"
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
