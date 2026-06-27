class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.44.2.tar.gz"
  sha256 "42ff3648c43fec9be07b67614a7b27701dd4e369791e18fe09a0ea4f9e2404b8"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3f1c51c1e0296a85a1be3cb5094603c5b41e36267415273fc8911d030dbc1c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3f1c51c1e0296a85a1be3cb5094603c5b41e36267415273fc8911d030dbc1c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3f1c51c1e0296a85a1be3cb5094603c5b41e36267415273fc8911d030dbc1c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "577111d50266ce923a0c877a4be52313f699e4559b2f8e1c8aa054fd36e8c30c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e4cb1cc453d4b99cc0a911c1bd443ce3f90755428ef5257efe6a4928a083965"
    sha256 cellar: :any,                 x86_64_linux:  "fd45dbab7b7759eb6fd4605d666cc8991848a8ef95a12bd5130e83801d4be203"
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
