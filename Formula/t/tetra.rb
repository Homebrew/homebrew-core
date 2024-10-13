class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://github.com/cilium/tetragon"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "da2da2b7ba4f3374753c0631bda543077e5622897e55c421d4630b2e72d4017e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "10bc0b3d524d8e80b6e1cc98b8d88b3846ffe01e9ccde1163696b63641d80fc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50fb94ac3ac61b4605a4f51b66e8ac3b5b3e9f7ff94b65af75684ae7985ff0b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1081c8068ff46a4e68570fefa9b475152a7a65c3f1bb0a16ff2a6b4449e94e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae93a369c0fed87d0e95a747f122053d34b8d8998fc09d5d533c7fdd1bcdeb44"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e8c77fe518c20638c07d1d72e08dfb2f6f7eaeb60f9fb7f5e2f7c976f859bb6"
    sha256 cellar: :any_skip_relocation, ventura:        "3d0c6fe8601747a29e456b4097d60d55b66582da36861d24438f1274ae3fa75d"
    sha256 cellar: :any_skip_relocation, monterey:       "563d806d8c6e05cf4a4c10c523a81cac426aef44820747f36684d84f184bd23c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7601b77c82e76d2401da7ee0005c32fd5557d67fdbfc0d71e9dd120b802a4a2"
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
