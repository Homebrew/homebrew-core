class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.42.5.tar.gz"
  sha256 "98e058a12431ae7016578edfb61debbf9568b5fd9e53eacdc8015e2746b12857"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6081f98d1ab486713e0350646a77d02324ffd94b8752d72aef0a4d05fcfa0aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6081f98d1ab486713e0350646a77d02324ffd94b8752d72aef0a4d05fcfa0aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6081f98d1ab486713e0350646a77d02324ffd94b8752d72aef0a4d05fcfa0aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "83e62c3c725f995ca03a05e28af8d28cd66bbafdc584546e43dbcb15ea8302ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85b2cb543da54f5f08b96e155b99b133fa82276aeeb7cedb4e2c876f56624b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "932c82b8fe062e86ea451bc34eebd840e18e041174ad81a04ef9f5bf4c007f4c"
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
