class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.42.2.tar.gz"
  sha256 "f0607c1e9183197f1ba97fa494e1e35c4f3f6ff6e8f260e07bbe16114b2ef300"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "838198cd152183569111dcc2ccd1f8150902680fac279d749b3a6bddaa3e7a7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "838198cd152183569111dcc2ccd1f8150902680fac279d749b3a6bddaa3e7a7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "838198cd152183569111dcc2ccd1f8150902680fac279d749b3a6bddaa3e7a7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c4f728c4c1a9cdbb95be08b156976eb214830a4516f1e57a7e3aac46b6500cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f336c076c5ae3a63d472ee25f0f1b97078ea8ac4abff0b678c8d188f8ab7b45f"
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
