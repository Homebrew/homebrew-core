class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://tetragon.io/"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "4b38bd34fe17be4abcd48a58e22f9811aef5d26847bc90d0f74b7eee70308e36"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2385a7748190637f01e9388d89d6ee3defc8b5d930415dfb73a9715433eca9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6cb95ae2683bdb64bd81a167830baffd884eeec6bb9b48ed16be6f80a8253d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29a696880f8fed793a57b83c12ef9f618f59e4bf19fa19eec6ddc5da8479f93f"
    sha256 cellar: :any_skip_relocation, sonoma:        "281b242f7adddaa7a673662d0585426f13d83cef996f0495af05696840f9d162"
    sha256 cellar: :any_skip_relocation, ventura:       "7942959321491d997715d7d35a9c4b6b5b67dbedfedf629b50fce99a8c9972cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b381a6a35bcbed501ac9d9bed5474bc9b7afe17b7ee7b4b34674b3646b5ffc07"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/tetragon/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tetra"), "./cmd/tetra"

    generate_completions_from_executable(bin/"tetra", "completion")
  end

  test do
    assert_match "CLI version: #{version}", shell_output("#{bin}/tetra version --build")
    assert_match "{}", pipe_output("#{bin}/tetra getevents", "invalid_event")
  end
end
