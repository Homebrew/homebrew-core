class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.14.4.tar.gz"
  sha256 "17b5c3b2dd2b318d51ef392aaa4b5ae025b2b0b694884067e54ea90990b9ebde"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b2637679cea2623b91db3067331c6bc530be90ba1cebcc74b8509f580f4bb9b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5652640f4cb321e3b3606c1686c5489eb25f14eaecc36c07c2e5de8b46015d6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c552bc2a0f35c05558bbbb1070a01792544a4e99db492960f093481fd0c13514"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3cbaea7462968ccc09f13dcbf0d17eaad7f4165bf2f902eaa7ce3a3c927e2248"
    sha256 cellar: :any,                 x86_64_linux:      "f517ee2f2e65196317035fcda77b3c8151fbd383252be4476c54477bed16d17b"
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
