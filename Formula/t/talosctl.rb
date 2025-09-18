class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "41cf9481ea2c1dcd0dc65c0893c90d4939d4bf187d36c91997dc95073c5e75f8"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de6b813806af5903d0f2e129fda2af0817e5ad36b137ee0570a9974aa9126caa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a0e60bde0b99247b35e98ae240efb2e71f28de5f4347d02931006f2bf51b08d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "783ccbad2a6928aea24032388b3a512f4d94d48951ec861731207586f9ed1f7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e94156e33a0baf48098dd7b23b1eff5dea11f783e397eccc254ea644cec8952d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7708b2792dd0c04d9e6b0614343ddfbfdf13d3ab7f18b803c5b2285d62dc44d5"
    sha256 cellar: :any_skip_relocation, ventura:       "139f44f76e149fdd08cabaead26f1003c1aff70b53e96228adfa23c398710e50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "262c222da55e15e6d6e851edf114cb168e01f63dfe7ac09c4f8ffffb2c284d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b71629816c21564845e467e7a81dd457cf597979554d8c1d3a2cf17b83253939"
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
