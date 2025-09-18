class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.42.1.tar.gz"
  sha256 "5676623ba79130da3f53d095535cf12cca6b22c981701795d2b13f7b786cac76"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e37808a2eea437e0ca8ac22397b956bf294f22df3a4ce99dbeaadcd750da87a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9fee189414c6417d5f5c786971df07c631a483e3887763d6be14881666f6478"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9fee189414c6417d5f5c786971df07c631a483e3887763d6be14881666f6478"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9fee189414c6417d5f5c786971df07c631a483e3887763d6be14881666f6478"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d6240d0b9de247de1dc4c6b242bed7bf7c5c63635239fafda8f5ae392ad9ae4"
    sha256 cellar: :any_skip_relocation, ventura:       "9d6240d0b9de247de1dc4c6b242bed7bf7c5c63635239fafda8f5ae392ad9ae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09b2c7f5efcf9ffbcb51ae9a9867a26c1cfa101757e714555551203a2c871191"
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
