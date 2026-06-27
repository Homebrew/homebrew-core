class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.11.0.tar.gz"
  sha256 "37b13efe95241665fd59b7d5e53809c70533b1b0f98fb39e0d4a808a3b7da639"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c39a1165f9edd40ac95f077bef5f76c0e185a79496424eb87591b53f44b3d2de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb969109ebefe5f9d16785548bdaf9d79b475f8ab6267d8bac757942ae50a62f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42f21747cc673c217e763545392c717838203b7dfae7e9bceef06bd69160bf6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1ce22f1b320148050c3c22d5b1d961fbe6829880955eb38da8a7b4171be1cb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23c304cf5208374b745b7972faafa41da8fcb67a4ebe9446d843749832d9f433"
    sha256 cellar: :any,                 x86_64_linux:  "b1bf50c2cae5740c1a0ae36f9c6daab830eb71c4ceae346217274f23de5df082"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get testworkflow 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
