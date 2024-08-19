class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://github.com/cilium/tetragon"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "67d7368d82e2aa455bdc06704a7af5c0ef78406e65e9bd6d3f57e5550b7a3eb9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99e5a8e52bde307609735174d8c9925b9b64c7683a10309ad585be4232234e44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c8ec607d3552789bb6cb7467da2aac5b6720b3e920054e6fb543afd6286fb52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20483f4596226ec7a1b0c52901d64ca4fca13f504bfe75f6c78ddb07c85fa126"
    sha256 cellar: :any_skip_relocation, sonoma:         "a577812ce1a9f6920ecbd1aff86e49babe02af6882875d3f7c7f3d60cfef1000"
    sha256 cellar: :any_skip_relocation, ventura:        "b8499209831fec4bfac948df064d16a0d2437a45cc3defd7941bf3a01ada5671"
    sha256 cellar: :any_skip_relocation, monterey:       "35eda4da7c435944362ba527cd61217e5a76e8c2003baccd85cb055f703b0d15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "933a7db10db2dea93b67bb3d473e34ee4c3b1738199d3a11c5fe25eb85d52b09"
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
