class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.43.5.tar.gz"
  sha256 "ab9a9e622ec5386b4c766abdcbd007011c1388144983a6ba7c4a9b534c3d2929"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62ba01f583b4853d37b736bc198229de6702343883daccff0a869d75e92036a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62ba01f583b4853d37b736bc198229de6702343883daccff0a869d75e92036a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62ba01f583b4853d37b736bc198229de6702343883daccff0a869d75e92036a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "795218ed5c6a0db3d043dfdc0e65de36e74a7232906dc3e3fb27e9e71318a6ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26a8ebc0499290cee5a55707edf62b0323709736248572b8bae70e66f09de24c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b82068bc2887c8ec2f1b6b20d3a095b1ad87584aad87b12bde18843c927fb66"
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
