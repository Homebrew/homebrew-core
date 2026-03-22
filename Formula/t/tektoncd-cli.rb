class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "1b6b70947056ec98a9e4f303ea802f44d150cf16363125d8b8cab20d41e3a91c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74167dfe12ee79135997188ca00ae00d86229da6bbfb2878a465024f711623bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20b944d78edb01acbf9e981e735012e2eb0a5374b9cbd4c90b7c17e75e597a75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cc4e5486c62ef3b6ad337ecdb9e7216d0ef99e19d014e412392f2283654f680"
    sha256 cellar: :any_skip_relocation, sonoma:        "29bd57515c92aa5ddcc296b2a48688852ee310ac00d8abd845f027e81e710c25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea164dcc215d96ddb041783a0fcb234951869f2ce05b2992aec9fbf8ffcb3ef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "908580e077cd7540135089e64e386a66b6315760be2f21165fb0a77544a91d8a"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/tkn pipelinerun describe homebrew-formula 2>&1", 1)
    assert_match "Error: Couldn't get kubeConfiguration namespace", output
  end
end
