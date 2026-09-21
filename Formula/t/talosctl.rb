class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "49710f8a98f9c98f88453cc2d5ebbfe5c128183785684a9defbc60ad5c76dd55"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ecc6c9efb9fa82bd29bfdbd70b8ab3af2549ac43c31bfc6b31daeb3201a34d38"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dcb78ff7bb8e7dce6627bdbbd8771ebef1d013764c2ce1bc0dccde684643cc56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b6fe0adbfd86ede6a9499a7ef6d74f4a1fe312582e546288a30b7776416bb551"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5d24c6907354f61f674d7ae3a4032d9197541b6f8fde9266f92f5239ba59b06b"
    sha256 cellar: :any,                 x86_64_linux:      "57510e0d07534a33b474b48388aabbb1c662d4cb01113e3cf03d4e8c72430520"
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
