class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "41d89d3bba1c0a5b1713cc72e09167b99048da79d0fc6146561a458591b6e45f"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "670fa71becd64f64c604f8ce59eba8645407eb16afc1ae5f6b212a8fbdd4d821"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "954c439b26189eaf02f287605d1ba4e0fe8ed465c19c5b3f706c95652c92c9cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "475a4bd4073ea19658469b85c04a799335c5fd08f68f4a1ba5cd2ef1ae57d03a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa7a2f05a141fc1ae8f436088ee63f80644ab73db41e6bedbe01fdccd9b38936"
    sha256 cellar: :any,                 x86_64_linux:  "a8e6a14fe611ce8b0ceb3cfdbdf8047ba05f1e12f98f84def730eb25fe4afe2e"
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
    assert_match "failed to determine endpoints", output
  end
end
