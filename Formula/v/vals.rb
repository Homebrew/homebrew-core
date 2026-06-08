class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "d6d0104183afff848913120788cd0b9773e6ef03fcb231c21953e523a720b0c3"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "770aff808527878e6af11537cdac513921d1e44bec120fc339dee7c561a76f37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "770aff808527878e6af11537cdac513921d1e44bec120fc339dee7c561a76f37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "770aff808527878e6af11537cdac513921d1e44bec120fc339dee7c561a76f37"
    sha256 cellar: :any_skip_relocation, sonoma:        "f44578e7b5c0f183f985a9beb423f22d8e44ea833b0c258b46752154a9163d9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03097f98d223a9601045c08192fb769848fe4d9f257eaf9c7f8ef800c3da0cbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89f617169cdfab0d5ae50106dfb99256752a3caaa71caff6a1f164ad65c147e5"
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
