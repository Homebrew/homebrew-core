class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.40.1.tar.gz"
  sha256 "3eb7a45d02f2dba39418ac44bec48069b23c5dc14b358c14a0e857abaf3b4117"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fbf08791c60e2660d9f155fa4c73fbaa666585c4656a5696e2ee9264211c793"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fbf08791c60e2660d9f155fa4c73fbaa666585c4656a5696e2ee9264211c793"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fbf08791c60e2660d9f155fa4c73fbaa666585c4656a5696e2ee9264211c793"
    sha256 cellar: :any_skip_relocation, sonoma:        "3926c677ec8028485fee0438d8ae05bbaa19fff6c87b19f3394b3f38de4652c3"
    sha256 cellar: :any_skip_relocation, ventura:       "3926c677ec8028485fee0438d8ae05bbaa19fff6c87b19f3394b3f38de4652c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96633551002b509651920adad186559d4d4a825626ec7cf8aab0db751e8b9feb"
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
