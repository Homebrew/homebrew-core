class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "a0f2b0f0ca69504a57923c2048f799c8198c6e372566a8b90eb1af81384cbab9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "55676c9b4551cff4c7626bba50fda0bed2f254f61bcbb66199576d1a0aad3b5a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "97ed4aebcb5e450118c28fd04448c7ac7be98686c520af950afef0fee070b2e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "beab28e9eb6ee05168046b86f9647cc0c58ee0019e479b7e5408e7dfbb0fe2dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "25d4ccd7277170cd69febb8b41a349a400cafbbcfee4f5cd6e32cfebebe7f3d0"
    sha256 cellar: :any,                 x86_64_linux:      "a8cbf15958948fd092dbfa69aaf4705e819481825ea587683c969d3f8670776c"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn"

    generate_completions_from_executable(bin/"tkn", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/tkn pipelinerun describe homebrew-formula 2>&1", 1)
    assert_match "Error: Couldn't get kubeConfiguration namespace", output
  end
end
