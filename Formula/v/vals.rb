class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "aa1133fc97a3ee75de0c7e3ace19324f7ab1655296e017f53aac9cdde9f5c759"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdc50d4ccfd6d18013c51304922faf4fda5b13ccedca9f5a798df5197539cd51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdc50d4ccfd6d18013c51304922faf4fda5b13ccedca9f5a798df5197539cd51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdc50d4ccfd6d18013c51304922faf4fda5b13ccedca9f5a798df5197539cd51"
    sha256 cellar: :any_skip_relocation, sonoma:        "0392f355fd063a7b2597c955c4af079d647d5627a67dc3d330812976e74c0c78"
    sha256 cellar: :any_skip_relocation, ventura:       "0392f355fd063a7b2597c955c4af079d647d5627a67dc3d330812976e74c0c78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "417e63d659f080edf35a0bf1284653930aba9ce15b1db7c5c49c3a724123db34"
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
