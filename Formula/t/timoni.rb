class Timoni < Formula
  desc "Package manager for Kubernetes, powered by CUE and inspired by Helm"
  homepage "https://timoni.sh/"
  url "https://github.com/stefanprodan/timoni/releases/download/v0.38.0/timoni_0.38.0_source_code.tar.gz"
  sha256 "a57b3b7210659eff86691383cda2bfa97a1ceea7fa401a06ae19ac19774ac3e7"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/timoni.git", branch: "main"

  bottle do
    manifest_sha256 "e4f1a14b3f35c2134f5e71f59282b334741df5eafa782841ba14f2947217cc19"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "633d746a791bb45ed67127a914bb3621686befc35b7c8f39f39c85b66cc1f352"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d8038b9b239801665283ca368ab4f4a29e1c1edb20662ce230628cb3b848a30f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cef2e21b812e2ce749df1436165adf0e698090ccb58c72df1dd82ec91b637cb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "438c200b13db5d6b5295209567497f8fb5624dde53bf2b3f1cdf6bd5969ba68e"
    sha256 cellar: :any,                 x86_64_linux:      "92d125a4ca40facb3db9de1a0c46ca9a127e22b4358986af805660763bfac58e"
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
