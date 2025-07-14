class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/refs/tags/v0.41.1.tar.gz"
  sha256 "08cc174392261d3201685b863390ff28207a00df3964acd754e36764e25f60a9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24eb337d09e3ffc0034a2d5003d7857f6f5f8eeb1d219cddad0c3a44c1fcf6af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ef9f10f2addb495a65233219bf5e986ffce3e130cf6c3e01a928e52e0cb8443"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb9356554e5e42422463c858fdf03424af6dfcd3fb22d32a62b46800f50916f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c89cd01aca3f22d65b12c66132572b11e2c2ba78542d7d488153361a6b62487"
    sha256 cellar: :any_skip_relocation, ventura:       "b75deb10de1c1588c85951f0518f3ccc03a75168609a5f75bb9aa56bf0be2b69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04ad1bd97c9e68bf9b5e61c9ce06e3c092fe442a751e3c471c2545eef6d29099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd923ac4446ead8a320745e614bff7165a907a7cffeccd6a2a446232e85e1473"
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
