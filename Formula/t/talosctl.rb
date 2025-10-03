class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "b43168956aad4cb6aeb08bbce1fea31477204e44ed1a99b1a50880ceab9ad6c9"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d07cecfc715ec1846917f4a347fa97a9fcbf5245e2d00d514d4a1aecb326878"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2522855b993ff477f2eef9541d543e5019a6ccde6bd93a815a0991260b756914"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8187f81cf2ce0261f27a8e40b25d53292119d1ee890571294d6a51117016ac2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "83c3f8ac98303d2873bdd8f769ec95a102bfc0cba01c7134c232afb4033deb99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bef871eeb8a768b91cb5ce1fdf7dff6843063a8857d15a941cd84e8d606727f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbdd37d99999b940f1822c68a16caab8379d69f0654b0d4bf1dfe651cff38b6a"
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
