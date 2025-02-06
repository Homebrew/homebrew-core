class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "1a36e881517780a363d806dcc3005c5285b3f5772d78d10e5d1b17a68876b5f6"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8385bceb44e6850282a3aaa0ced3dbc74fb369e4ab446b4d76e2a581d0ebec3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8de440391442db9c7595c3abfb75d5fe71e13a155a8c83069af739a208942f8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c1371328ff05ec5e092bcd978992251d82569f526ba4b2b0167dc2fa7bf03a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "468d22957734b7d28f778453d820649016523de73eedd91e52b9229d12ec1c84"
    sha256 cellar: :any_skip_relocation, ventura:       "27d3d197212b2e9bfd01d248b9d037a03fbe24e64c7f167ce3a0ded62c1f1e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cc21a2f583c2bc6106b629017b116fdb02a2a1e97813ff3a25062f3e08739fc"
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
