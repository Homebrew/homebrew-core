class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "26ac3109a265de8917a023e9111e34b59e5f2a0d9d7e6b5b0c543b771b9bcbc4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "857e9b96087e13801e43ebcef0baa5c1e6b2d64fc9bb52922266224fcace80d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab319a753322d43b6ff97d7769b1d01eedd649b4e3297b2767dfc328bccb7455"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1e7046369dcb8a46f2fffb92590b4813eb8de74534770c4950301561196c9c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "278b56a3e17ee75fa8017b6080510917411ec9e034792c44744610cbc159fc2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1c0516b27108b1712301b1d78b503c8821458d6642e57ae8b4e2c50524e861c"
    sha256 cellar: :any,                 x86_64_linux:  "7f6ece1c7a1c0c954ff957fe2f9ddcfc2825e7e6281a6453ae403bafd15a3b7b"
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
