class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "b434088571bde59a699d9c053bfa219aaf77bb13dd027831a2493f80d2dcc8b4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b284d44b31fa614511ecde0a828de970c38b4cee8ca9b10842600a818ab1761"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc1382d8bd6648768348ac672cd4090ebcb57c6929c61454a17050d786b0cd45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bc468ce1dd4bf09dd6520510d7c2f7d273e9463b3e15d1db81f4087d3c6f666"
    sha256 cellar: :any_skip_relocation, sonoma:        "294194d4a4ff864ef8e5b6cbd9e4644815a9762aecb5012e4c6aef1feaf61feb"
    sha256 cellar: :any_skip_relocation, ventura:       "27f557c41164310772b24ecbd3f110f07ac0830c687937aa887584372b018863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "227ff65030824d14d6c5b9e934bff191d5c6a3f547fb40090b21ff65bf59aa6e"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", "completion")
  end

  test do
    output = shell_output("#{bin}/tkn pipelinerun describe homebrew-formula 2>&1", 1)
    assert_match "Error: Couldn't get kubeConfiguration namespace", output
  end
end
