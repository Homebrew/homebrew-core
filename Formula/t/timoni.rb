class Timoni < Formula
  desc "Package manager for Kubernetes, powered by CUE and inspired by Helm"
  homepage "https://timoni.sh/"
  url "https://github.com/stefanprodan/timoni/releases/download/v0.37.0/timoni_0.37.0_source_code.tar.gz"
  sha256 "8d86203b291a6b3790d07c4c53658b1fb251c9f341c94f424afdede43b5d8959"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/timoni.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "211a035ea172378bfd4889b534f4e62d7e52d5f0b93bfc615618e99fedefaa96"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cd0f315f4196bd7abd273885b3b022785d40a28710069069722577d45e9acd2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "651fa177ff52787fe04385c306978f782522b88be329c6669a2d734a287482a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8b47619c17bafb6a047f81e0146098945c94f6a590b08a8ccbec5b07183ca916"
    sha256 cellar: :any,                 x86_64_linux:      "fe59c4ca7eec3cb70dc4b63de5942f516da765563ed495ab23063e5705cced5a"
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
