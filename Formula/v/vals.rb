class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "cf96c8f554260ed2ef64bd551625809189bae8a40db57b4776d11826c20721cb"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7a51afa8fae54dde0e65715207216f3e62567b1cf29f6fbc4a5087ba39381c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7a51afa8fae54dde0e65715207216f3e62567b1cf29f6fbc4a5087ba39381c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7a51afa8fae54dde0e65715207216f3e62567b1cf29f6fbc4a5087ba39381c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b31a57b0905fa42e8cc0db07e83d85b7222329833a158cc7b656fd94b43d016b"
    sha256 cellar: :any_skip_relocation, ventura:       "b31a57b0905fa42e8cc0db07e83d85b7222329833a158cc7b656fd94b43d016b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05cbf236eea9cfd72fc90657a7c4b7ef63a2a6d807187684d1b73072b822ebc8"
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
