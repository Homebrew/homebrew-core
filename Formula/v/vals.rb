class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "413b60e0abc9ef39a52f23b994f3b857d5e45733f33139899d7f1d68256bf142"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4507e2c399f2683021ae16d4b0100ce9196c5733a78b88c29bac00cf46212b8a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a7a8a12a0e5d4b8293edf9de2deae2ed3de7b1b4e2410b5bde42db5833c89716"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "292118a7036df92abbff195cd3e4c39ee1aaffdb7063140edd41e4d3c7abbdcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "76e14ebb3784cf0bdc79e6eb9cf4944ee27602d1142a9f9b028e9c7356e96abe"
    sha256 cellar: :any,                 x86_64_linux:      "aae89675a182a9347587267d98fb7bad7de847c244c77d6e01944a702bbfbcbf"
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
