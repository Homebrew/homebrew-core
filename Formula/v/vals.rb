class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.44.4.tar.gz"
  sha256 "cfb28b29d1f913322e3d7bce7ae7e9d83ed13dfebf57459189c791eb9e7ba208"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2eab2e4f57f6ddbd60642a87f826d9917ed1dd0ef8581114fd9edac3603958e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2eab2e4f57f6ddbd60642a87f826d9917ed1dd0ef8581114fd9edac3603958e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2eab2e4f57f6ddbd60642a87f826d9917ed1dd0ef8581114fd9edac3603958e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f9d4d08db25fb4caae4d92a5c67fda90401bbe80655c4f67b7ada1d6a0ffb8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa9dc2368177272ce7c70c411142626b8c53733f70c9a3ff6e08282193bdccd2"
    sha256 cellar: :any,                 x86_64_linux:  "0039290353abc541f644c9d790a842a7eb28823de4591fd496a564a195822146"
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
