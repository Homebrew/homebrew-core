class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "c1be92f6ee4f1521c56bc2770b5c9c3cd6bd56d1b2b75db65c2c5ac10ef80bbf"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47900c8284ccb9344e73e4b7459fb2dd2412e22ba6d80e44f8ad1695bf1fbc8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47900c8284ccb9344e73e4b7459fb2dd2412e22ba6d80e44f8ad1695bf1fbc8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47900c8284ccb9344e73e4b7459fb2dd2412e22ba6d80e44f8ad1695bf1fbc8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b820c0999a3b9b7e4bc13929fe1f6083c5387785392e20c4587c8d86d3c774eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4241000e808aec34f38a0196a74cdb9e802f0423937d61d6171ddbb2f2d4720f"
    sha256 cellar: :any,                 x86_64_linux:  "8f4c472e82b3a7e3fb8f02fda906b7c4aecf5df488eac983c190e64f0bc830bf"
  end

  depends_on "go" => :build

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
