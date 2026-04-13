class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.43.9.tar.gz"
  sha256 "6996f73a0b8fe5eac747605c7449e8d809ca266d2e121acb5bb1699b10b58d7f"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebfd752f872f2c0f97575f0e2d84b018118ac83dee5cb7d91e133c8ad825c74b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebfd752f872f2c0f97575f0e2d84b018118ac83dee5cb7d91e133c8ad825c74b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebfd752f872f2c0f97575f0e2d84b018118ac83dee5cb7d91e133c8ad825c74b"
    sha256 cellar: :any_skip_relocation, sonoma:        "55547930ad6b8bc5c893fab9f46e34fa062b1c4b409316500318392677a333cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "848de899987f2b70e88e83d97f0c9d896ba4c79525a18a5b767a86815867c4de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad328e49d198963ca791550a3aaa4c464315181746f2fd60bc54098eaffe001d"
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
