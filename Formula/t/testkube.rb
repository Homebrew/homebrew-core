class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.11.2.tar.gz"
  sha256 "d1d6ef449d2e3637d14c939d71328ff4f5f28a4329cd554da7e565e6e01777a6"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36157c2dd3e9e3e3883caa24a57dd9d950615f783c88d2dea4e34cd6368b7f57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f96dd3729b5e73b78d1222b33ca7a966445ad6bc3257bab061db3a67fd0bccf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25ee2dfed018f2ba9989eb9180a87d7143f96047fcfd03cc96292ddb4c2267d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9008cff67ba55ff95620c7357b9d638b89e4f78c475cfdbe552558d96f31bcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1756e3e53cee5f937ee60557b145d95a22487eee22e5814690ce1df0ce0e258b"
    sha256 cellar: :any,                 x86_64_linux:  "bfa89a5e81e410c197c8279d6d11f78d1eafaf6f6cc4cce9abd518c70277dd12"
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
