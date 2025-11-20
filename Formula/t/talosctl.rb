class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.11.5.tar.gz"
  sha256 "6e9610edce860af0131cbcde9b688e7d10a67a7784d8be8a39e6c5540285f2c2"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b39e305ab838d937786216894d8ecdf72f9baa07531b7a98d92a4732385a1005"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb444ebb2da3ad0b380000c6f525ab835452d2f7e2efaf9ee2a396f98e919183"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0b720afad134b0accf41c44229e67387ee846ddbf1c09fb4537a3df6b95eae4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a5a0bac2a25fa5fb54a4edd387ed3e29049e0cab53ddb415cc8dcb214eecf30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2780378388fe148903ddf7f8c6b3426078ca745eb02eec725f389e571f7b5c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6697cd78fe2e9f5a92dbc106502431f19c79f7d336841d651f96a6ef3d92341"
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
