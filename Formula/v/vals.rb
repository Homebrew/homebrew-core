class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.43.7.tar.gz"
  sha256 "49a546ea19113fd08745720ab9a231eff9adec26868c2fed53dc0a761b3ed196"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c88cd03ca3942fee69f5765ce993b5fe923d580786637339198ea149081656a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c88cd03ca3942fee69f5765ce993b5fe923d580786637339198ea149081656a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c88cd03ca3942fee69f5765ce993b5fe923d580786637339198ea149081656a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "46efb8cf7a447674f9725656b32ac6f89cfea4bb5c54fd22410baf48d9ef50ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be9368c8b07106eaea39ad04d05854f29d4f9bc82a21bd69cd0d07249fba7276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86a3fab80178b5ebd24a084499b295a170eb1e2c2edf4a71a677c8c902c8546d"
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
