class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.43.8.tar.gz"
  sha256 "a05fdfb08a065cca20d399df1d79cba665e2a9a9abe26ba9cd82d253dc9d4197"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be1a04501634a831cf422dded590c36dba2836421c14eef0422244e1e8120b47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be1a04501634a831cf422dded590c36dba2836421c14eef0422244e1e8120b47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be1a04501634a831cf422dded590c36dba2836421c14eef0422244e1e8120b47"
    sha256 cellar: :any_skip_relocation, sonoma:        "c940bc6cedc81e65ef80ab220579c6a09fb7024aab8d41e0f11e46fe457493d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a5686e6205ce3af53d24499bb045d092de040b28e9e44d3b9dfcbf56ea6fd71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8761ceb2e2c3bca33e030e6c41fc0502e3983ec98756e8e95f5b7e7bc8ab8d0"
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
