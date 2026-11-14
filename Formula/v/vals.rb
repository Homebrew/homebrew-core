class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "d132c1e739d837f3e2321ca1d215915dfd6d78a6c853ed8fd0bb1d6495dc7069"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f81aae07a0d27d004909d3cc6744b4ef81c2d59e3a01e8b89c2b9bfa8e274971"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "668079b59ef43cf66db2c089f4364b65f1e65ed6c15b85e0b512dd7f8e5727d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d29c7c93728cc35ec037c53e0b177e1961d53bc56147ce63e2cb5dc9068b120"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1f22fe7369b89d95cb1fa250c4e1d907c798ec90ac52a8655938785820339c08"
    sha256 cellar: :any,                 x86_64_linux:      "cf8293e467479ebb326de5cce47ae9b774fcf4e079964a4b4e2137c5aca76ec5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version} -X main.commit=#{tap.user}"), "./cmd/vals"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vals version")

    (testpath/"test.yaml").write <<~YAML
      foo: "bar"
    YAML
    output = shell_output("#{bin}/vals eval -f test.yaml")
    assert_match "foo: bar", output

    (testpath/"secret.yaml").write <<~YAML
      apiVersion: v1
      kind: Secret
      metadata:
        name: test-secret
      data:
        username: dGVzdC11c2Vy # base64 encoded "test-user"
        password: dGVzdC1wYXNz # base64 encoded "test-pass"
    YAML

    output = shell_output("#{bin}/vals ksdecode -f secret.yaml")
    assert_match "stringData", output
    assert_match "username: test-user", output
    assert_match "password: test-pass", output
  end
end
