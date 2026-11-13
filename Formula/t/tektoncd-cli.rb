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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a98297736b72e4f91d2f28011c3813b35e71dc2ad5e0cd510027db2bc301b4d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "621846a5517f10e57fef96186fcc451fde249586f1e7b98e68149c90c2630080"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "90792397a5252c6f5c39a664279e55aa349978ff90f5f180965212577dc14b1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "38886b115e2e2be91c7583f2a123f28963ac9893352d32f66a282a240423eb12"
    sha256 cellar: :any,                 x86_64_linux:      "923de021f94f5f62c60b19115d1a66badeace31ffdf6571fb7845e1d7d1dcb6b"
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
