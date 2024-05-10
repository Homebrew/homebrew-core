class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://github.com/cilium/tetragon"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "07f0e1c0a7492c64324abde277e283f096e601408ac8edb242097dd5c14d70c1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e17ac76269371424ff09c600ca10cb2d5d586e7ca09b45d48215fad4b35fc6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "665589f2f711df7b796c5cf1b8bc03ca2759b708f532946c2dacbe8e0dd2dcc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79bdcb77284a8c0716b138c86b69c917a07a2e3c5f5a647aea87165669a36dc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "233278a6a05a3e4039e94ae6020f012fbaa00d58d53ef9911e4e66f2896e9f28"
    sha256 cellar: :any_skip_relocation, ventura:        "2f4c300764de924bb541fd3e053c2e3b4dfebf8c73a2f7822a38843b7ed6be06"
    sha256 cellar: :any_skip_relocation, monterey:       "ff087413013642b72c2b2776ce182075ee4107face6e3e16c35fa0eb69998e57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42e2b31a9ec0bf2cdfb4840df0de0ebac5e905127dd8c5567d4cc781635c8d4a"
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
