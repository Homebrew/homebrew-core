class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.42.6.tar.gz"
  sha256 "a7e8d8d811e7f8180aad7c5fe70bc611ce5b9a49f4d999aeeb0b8b50a2a5a110"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0fec3d48a01dd2363df78c23c49a359f27b642d0faeeef5e88fe34b314ac78b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0fec3d48a01dd2363df78c23c49a359f27b642d0faeeef5e88fe34b314ac78b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0fec3d48a01dd2363df78c23c49a359f27b642d0faeeef5e88fe34b314ac78b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a3b9ab3d6de3dced460f1d04737482f510b92db035201548d66951fb882ce8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ef9fb8f2c191f1291efe287c67f173b026636c45c3f87e140964c8da01375be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffe2ae29e7d6a0248dbf012cd5ca2d81d14eb1089fd11bbe25132b53fa05ca6b"
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
