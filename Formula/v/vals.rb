class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.41.3.tar.gz"
  sha256 "03b9edf87e3846a93872253f1783f545a758f6e86a20c59e4d2f873547039674"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60c5c8b95a2354b45c8a62f99ae22488d49a7899db678ca11fe50660777999d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60c5c8b95a2354b45c8a62f99ae22488d49a7899db678ca11fe50660777999d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60c5c8b95a2354b45c8a62f99ae22488d49a7899db678ca11fe50660777999d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "33db687227784d80b9ff604d444e2d9917b9a29f26bc38ac4a51887989069fcd"
    sha256 cellar: :any_skip_relocation, ventura:       "33db687227784d80b9ff604d444e2d9917b9a29f26bc38ac4a51887989069fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93f3753ca6036ae8ad777314af01dc2d43854221749119647410f67d08a6c285"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"), "./cmd/vals"
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
