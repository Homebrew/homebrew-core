class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "358874864900c61384a80e779e156550e0f44a502eefbfd1326a12786a8d3b4d"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0afeb6320a3d4b3b0e3e937733c2fd0314660ce4267547d455986c743da5c04e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ca7812367b98aafed1ace50fd7609f2eaf431ffd87693dfe6155b199b8f16b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29048286346fbe1f29e6e86fb73ef38f617ab9efb021a1ba77aa0460d15feaa8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1258dfa5a3b4c65d6ae64fac8545d4e53bf6236d6ce78906c344449dd7c360d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c49548829574ffcf34ea498ba3d7ef7f8f1408d86723fbeffe209d958feedf64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c78a0428b964e36f66cb8d02ceddeea4bbb10059163c3ef7b318e47367e93cff"
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
