class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.13.9.tar.gz"
  sha256 "d8f328eb5963a7ee65eab01d1095ab14a127d03a2522c6050dcd0ca2b6447ed5"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "561ccce98ffb9e0a84f6f0599434875081127e8e1d9f818f162d0df5089532e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2e71d2b5ec7cfa2aff8a081c101bb5382176be18d9fb8bdb188d335aa3125ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eba555fe36895acfd71276500febdea54f4207bc749d8cdf2685f499c568c9c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "512fefb31c9fd61fe50f25ec4b18ade4d5faf8d2ba2d312301a944602ca3cc2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea011916b70089a6ebb3a8d2863de89c97de916d97f18246b31faabe26e07d1e"
    sha256 cellar: :any,                 x86_64_linux:  "5b40d335eb850d314965ba8c9a8942d32695534f97afb5013daa228af99c9c87"
  end

  depends_on "go" => :build

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
    assert_match "error constructing client: failed to determine endpoints", output
  end
end
