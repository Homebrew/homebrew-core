class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.13.5.tar.gz"
  sha256 "d3457377cf574d843f7aa4efb7f1263830ff150a153bd3e21ec93795f8c43f76"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ef6347b31c99a164738b0746fffc1ce3d039187aa7ec1168569f6036f2fa628"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0d0c5248f737a6af1c15e447198ddc8273ff37520ada9333b5c0bd5266aaddd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81ed1badbb0543b359b18cd34023c521979548331b494ccafc0cf58365c342f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "846ef45fac530bd539b3f4a402fb7316fe49d22d1f126e52ff450deec47d8950"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "573731ee3691271ea12b8bfc61619ea1136ed0ba6dacf916b69342c980e9d6e4"
    sha256 cellar: :any,                 x86_64_linux:  "70beee69846b05e5c494094a1429e0361c3698bc30d906fd365927e96ebe40f9"
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
