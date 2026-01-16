class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "57f6ba1597465610490e3c7b8f67fd6dc1ed14aadf8a274bd3e59a47b50ec725"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "871b258e1eb440d336d41d4a97613d7f4d3ce223af9cf14132355a9f2477b13c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e74925392f50100f1512b70d9134363767ff65bd18ddb169bf23a49c7f49315c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1401b0e4eaf421498083150083c750c658af9c4867e1f216fea5d7551e2a051"
    sha256 cellar: :any_skip_relocation, sonoma:        "146c00c111cd96ccd1ab9d2ad51af4e55f58f672cc7af2756103156d4c1c4a0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a079474abf10b41a102f8ac400ac5e2614b2ac066859d980f8e98cf1eb26c9a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb9b69b56a0059ed4450570a859640540c74e1b5c0a6b5635b79e8bc8da8a009"
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
