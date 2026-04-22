class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/refs/tags/v0.44.1.tar.gz"
  sha256 "603ca3149724b9923f0bfeee3562760b0dea83ef586484eb5eec630429346799"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d84bdcc255113a79dda158ebe69ca541bf725803e493e6c95632ac33a60c779"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d4a988e60e65881490029453651c3e4b6074301a9de96e339dd534451f130cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce5b178f573a0cd2d8d1da5e8e6312d353b463991b1c76702e0f629a7f1d753a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cef8dc80afd1fcc43ceb918dfd721a8bfe3bea5103fc2c6469179ba801cafde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ac00aa24063681193b0edae5826a08e45ac0cb5f953add9210847e3fc152cc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edbf751a18948bf90cf3a1fc9fa57772af2f5e9e93adf26826687ff3a503ee79"
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
