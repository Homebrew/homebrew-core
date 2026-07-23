class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.44.5.tar.gz"
  sha256 "afb92e93664870da150a4fa10c0f1e7dcd2383c7d0d4105d1f69179872a19632"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa83e67f7764b91002e292ec5d234321719209ce8b4b52134d1048b04391e8bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa83e67f7764b91002e292ec5d234321719209ce8b4b52134d1048b04391e8bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa83e67f7764b91002e292ec5d234321719209ce8b4b52134d1048b04391e8bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "49cbb8a38694e511301e68b26fa7d210eb9f668cf7f1cd84afc91272ca0e2519"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8aeec67e305665b989fa773c104fc156ecf94d31265c02f55d9bf22084229a6"
    sha256 cellar: :any,                 x86_64_linux:  "35e7426834208ad411bacb7e2a5eb0ad1b8116e9868f094fdfb4bfb1d2678180"
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
