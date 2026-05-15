class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "61e096008d9e6055d67399e7206db46df6b0320b5f322d4b7a2574fc98368110"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "665179708a023ba35d33559ac98f6f0d0c10a57019bda6cb25085eb567d1b778"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "069d729339db43f444d25aac712f36c199922b67b24f91e376937f27b745758c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baba80b64717c839f4b3a27f3e527d469df7bb16d922458ea424117561b688b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ece82d8fb4d33397e7812f366d57d18da500eb46f88b924c8b26f3ee77cf681"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67c7e998ed420df79bcaf2f5d143a7ecac3ad6430d23ba4812e6b2ff9048a8f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11c3f574a4a291528fc9e156be3ef17d3d2265f387ee65651726bd502059a38c"
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
