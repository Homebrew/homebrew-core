class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.4.4.tar.gz"
  sha256 "c7cf62a46210dd5f14259d8af9c98f9e9f14150f3b7ea11a21056c5711368ef2"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94e823525af798415e5f56b6c442f50337ac4580826fc0602a68c183e733b605"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8524fff20a6d78b5a21071c75f241ae873b7afd5c493a73665a2ab3a0fccc9f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad0497c15fa8dbb12d719a5f23a7e96179082ed5364a57e1bc25e73dad7eb7ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "68482aa2c9990a50d0863d94d8dbfe72f9fbf3c329cd82731f83f363c6043158"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1b27718b4d5a057bfc7bf249a172574d83c68fadf95bf5c305b9b1bdc42711f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7143c7119f1df18ccfdefd4e590aa5eff8f9ed551c6a23095fd83f0a6b151d10"
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
