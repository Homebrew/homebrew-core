class Timoni < Formula
  desc "Package manager for Kubernetes, powered by CUE and inspired by Helm"
  homepage "https://timoni.sh/"
  url "https://github.com/stefanprodan/timoni/releases/download/v0.34.0/timoni_0.34.0_source_code.tar.gz"
  sha256 "a82c0915dfa4026b429ad42e6042389a0e2b803c98931a50600d1a5fafcafdfe"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/timoni.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "106a0554d00a345935a8da637ec13881d0e0d94fa3b4bfcfdebbbd99d8f47967"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7d9ee3d88207f20c8ad04b32e55effb9a98c1aa9ab60c303d331769eaf467816"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8c6fabd04bfeb5e4e578cc6959b77af6f28051007ac7242c60d675cefd95b16f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "f5b6fd2dd8e19d7b7970d131f0e46ba3dd679953e31b3766cf0f9dc88d260613"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2c75ccc777c83b1ad9379b70df7b476e5f651ca706ccb0db29b05b8f53578e96"
    sha256 cellar: :any,                 x86_64_linux:      "35ae7c609532e9873a329cb8a828275c8b592fe55f54d7208245f92992661dd7"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=#{version}"), "./cmd/timoni"

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
