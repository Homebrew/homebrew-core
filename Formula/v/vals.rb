class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "413b60e0abc9ef39a52f23b994f3b857d5e45733f33139899d7f1d68256bf142"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3a3e6d065cdc5b34fb9144c19fb3f7a7954618cec7f1a8452ee55a9d588a6652"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d0876a58a706f0bdabdd592cd6d3ac9f9945033c14141f5efabcb3b560bd322"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a5c8799a7fda524451aa00fbcdb0c6aad8467a64f7157e6470cd37fe5987f2b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9920770b97ba745fa3e275eec2831c0d7b6f630a91c95d038f3581371a5560aa"
    sha256 cellar: :any,                 x86_64_linux:      "f8a209aa829705ab62a272bb1ac095cff6c9c694540cf6def62a97478e8e2486"
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
