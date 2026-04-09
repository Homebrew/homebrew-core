class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://tetragon.io/"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "e60801a44a24671fd5fc48c4c910d98ef45cb96aa9ebb3e130b164f8b4a8ff65"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ed652227ff68f2fa13f5dc8028188930fc7717b4c1cec711e418b3d4a591f1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95ac9ae48d198bee5fa1f63644062ec8feb9efabbe8ebda2d7a3cdd0544c2d33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "911043c6f703aeb97ed5b9c3313b0358f175b9fa5dd339000dc0fa78135afa2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "77c85be72a671f61a36aa66b460744830aa62fbeb80f64239d603eebe5ca96f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0502f5bb5511e3031fa6f0a89e61cd2ff172be8f6f2ff7d5a08fbbfb396be744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e610045f5fe544c1574bbc5a9d5cd472686ce7ea55d6384408f03c0f621977c3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/tetragon/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tetra"), "./cmd/tetra"

    generate_completions_from_executable(bin/"tetra", shell_parameter_format: :cobra)
  end

  test do
    assert_match "CLI version: #{version}", shell_output("#{bin}/tetra version --build")
    assert_match "{}", pipe_output("#{bin}/tetra getevents", "invalid_event")
  end
end
