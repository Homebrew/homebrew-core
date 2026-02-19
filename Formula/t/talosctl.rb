class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "2ed9dc0d227ebd3f473f6c8d23702bce977ce4a7d63556437218bdc2ef37cac4"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31dd17538fb5020736614c6e4bbc971a8cf6050dc88ae91efbcb1b48ae053882"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d001dbe150c9ba26d7c4fb7284fbeafb3e766078e3033d578daa420b903c24f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cfb8a8db74748c5be3e377606ee032da0d313ce7c7a1f2077fda88d9720f36e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7f6c58d95f63f6324ab4509a00b98a8a8fa9cf63373a349e4d1b177e2b9efe2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91a2d6f13fb77f82a3629805e2258e175d05f75cdcc9aae2c0ed8425e13d3f7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b2d928e7e024381f78890b9cfdbacd2ad5522fbd37407f0dbc7d93c85895e97"
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
