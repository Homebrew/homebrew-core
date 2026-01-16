class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.43.1.tar.gz"
  sha256 "df3d81d75aa37285c2abad60745c669f86c7c857e75925779ab38785721e80f6"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8c4b734dbd58569f0a8d68ee6b0399342e951c2c3e02114a1b14e2675d53f9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8c4b734dbd58569f0a8d68ee6b0399342e951c2c3e02114a1b14e2675d53f9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8c4b734dbd58569f0a8d68ee6b0399342e951c2c3e02114a1b14e2675d53f9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "77b8562d7ba93a210d811f54b6c3b47a0268f62a95735897dd2fb57b46aa56ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da82798c23d289a084d2ccc0d2cff545859287d3e3e685eb489a8c88102d4736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc899d9070fc9a10ca5652ca66f670cb2016a03c67aaa9fbdfa5dbbf39fc2e7a"
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
