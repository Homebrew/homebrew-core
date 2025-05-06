class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.148.tar.gz"
  sha256 "bdd1b73f914dfcd76e7bcd5c9e5103b3b8aec39da24f9c35b1b439b88dd1ba5f"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73839a7d72e0f0afc907793d6663ed3f3f36bf78485cc32272c995285a18f0f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73839a7d72e0f0afc907793d6663ed3f3f36bf78485cc32272c995285a18f0f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73839a7d72e0f0afc907793d6663ed3f3f36bf78485cc32272c995285a18f0f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "88d460d0ab6091e89139b156f5e6c18f831058b6088a2fa21e8fc4b1d7716e41"
    sha256 cellar: :any_skip_relocation, ventura:       "88d460d0ab6091e89139b156f5e6c18f831058b6088a2fa21e8fc4b1d7716e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0e2e1e96a0b2a9ba324f806bf78f0898e9b3a91a198670d47a0c7c044ae42e9"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
