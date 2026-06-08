class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "f0f42d68db52cec6f5e6f4da3994f7f4c9dca700e05b690184ea588251f92aca"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eae53ea34759d3a4b6b474d1bebc3fd9cf4349aab04486d0bd77c90b171d08a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ffeb08e48d23c8370756c344f74348fb3d06d67b0149d0353c6e0a08a993df4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a037be04cb751eaab57eaef0b6b8364e25f7f69d87818ed8f7cb49442c24607"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bc87c516bb0ebf8467de2618c105916fe2b5047e0a44e06461756fc3e15f321"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "227a6abb3297878b7cf4147af853b964efaa2d97a7c6993cde8e785b0278d11d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b16c8e8260c4ea2a334dd9889e8fc6ac56ed69834ebb9f128cabffe814257d34"
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
