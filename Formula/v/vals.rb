class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "578a04479e871ce8bad7983a9c8d7a703eb8082a869a23aa00814a24cf54ddd6"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a48f8b46a3c2c255554648f3a852f7c8380f526a692be611b517e21e32fe2ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1362efc15afa45e52f534c38a2a1acb3a59f7ceda58ff68188fdd0fee614b05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fe31c5b03bd0992bcda52247333c0b32672dd1667235b5669ba361bc947bf101"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0de7a338b83f4e845c806d7f1e0b369d078738dc6fbffc93eb7f6cd218dfc941"
    sha256 cellar: :any,                 x86_64_linux:      "8023daf79304fdcb236ec5a169e09a1599b49e0ce6833edc7d66ff17e054dd79"
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
