class Timoni < Formula
  desc "Package manager for Kubernetes, powered by CUE and inspired by Helm"
  homepage "https://timoni.sh/"
  url "https://github.com/stefanprodan/timoni/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "247d05e48dc6457bc8383534d2d1efc9d5152bafec32794cc358a00548725d1e"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/timoni.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "985eb65543c6d66660b51aa07720366d96b41552b1784b87f5f2fd40d06f76da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acb0e994d2cdfbd6dd5e585b2023e32226c46d3c35d0356322a055db6ebd6f96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "310f8d997f8b4d0c51ce67020c7711c0b2d4f1200ad8fbfe66f5953494dba727"
    sha256 cellar: :any_skip_relocation, sonoma:        "881a71472b9b239c67395e56b63a4280d959ac6da38000b0175077be4027546c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "937ed7f4c671083e30e6e68a3ee3ed5915aa79a1e1830a7029375396d5c57f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e987529e9b46b86f2094188368fd02daac82fb00728bdabb94e665c44b15e898"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}"), "./cmd/timoni"

    generate_completions_from_executable(bin/"timoni", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/timoni version")

    system bin/"timoni", "mod", "init", "test-mod", "--namespace", "test"
    assert_path_exists testpath/"test-mod/timoni.cue"
    assert_path_exists testpath/"test-mod/values.cue"

    output = shell_output("#{bin}/timoni mod vet test-mod 2>&1")
    assert_match "INF timoni.sh/test-mod valid module", output
  end
end
