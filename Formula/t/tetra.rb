class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://tetragon.io/"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "83469d661ca86ce74e75c10eb01628291088cedb73e2641029504b3bd7fb1f86"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd5eeed671d70196a85650b5cbed6983a65736fd1dcb93467f67cd46b49c3d1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2eed2fea2a2857a98f3fe6606a620afae50ae014211eb75e4c8a7080e4c2b65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1909076e0a335f5e09b2aa738dd1ccf93baf2cedac0ef4e72f6b47542557052a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d9f4f87022c5ff971733c04095877a0904e2549b4d4d7d090adcdb48d6d70d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce66eb92abce3d9e047ca52f8048a1b8a53693523b4ba173c3eceb392eade209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fa4268ef3b24e2d63b989a6012df5bda72d48e0821ee287e0b4039a2396c817"
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
