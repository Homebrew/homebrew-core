class Timoni < Formula
  desc "Package manager for Kubernetes, powered by CUE and inspired by Helm"
  homepage "https://timoni.sh/"
  url "https://github.com/stefanprodan/timoni/releases/download/v0.33.0/timoni_0.33.0_source_code.tar.gz"
  sha256 "69ae1b4a17bc37f88e0213ac2e3342a79a175bbbc3b5a19eec31ee3a725bd7d9"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/timoni.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ce24f7b869c6b6f3834e139b45bd8a791beb52086545b229f2d837e7e28c43b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58f2731b8803c01a8b17fa80cd29c73307804e4ffc75fecebebc2744abaf08ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c387f643fd8d84b2425c4208f55f67362ef27370ff01ab136baad87b7669e0a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9694abd36ff80621d67697fbd7f324846c21bb58241e44a2b052053a1cc9e0a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3d0c9be6c0a20a4571177ba7baa9588e618658d2e13febc2bbea4d9b42da9cf"
    sha256 cellar: :any,                 x86_64_linux:  "04a2d1686893e9e7ed3c567b9f56cde1819805a7d497cdc84f68ef61b0b3a693"
  end

  depends_on "go" => :build

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
