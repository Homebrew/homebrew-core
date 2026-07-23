class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.13.7.tar.gz"
  sha256 "2694a289d868ecb5ab2b0fcfbf61c452dfbc6540fab1c6b49f52d451755b5c8a"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14cfa40f4d87d28dc0ef9659abc1c06cc18136906f478b05065302b5e81966d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38f1e664e8c6a9f3571625004c667eeb16cd9f74ac627d5b486bf1d754a94dcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b857f9ce22b7d57e1766d963c746c452d4876b58fb19ec2c87ba1fcc95fbe5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5c37c8d6962090f87a565887d834d4404946faca9140c97ca622cda0be5dc52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10a68c254e5080a9bf8cb41b7f811e5c348ce6d9879fd6674f11e07859c474f8"
    sha256 cellar: :any,                 x86_64_linux:  "631c3f185a6360b395c278882c07627e00b17a0ae0401839e45864e35fca1892"
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
