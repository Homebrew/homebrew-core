class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.41.1.tar.gz"
  sha256 "313956c61f7103a34166f017964fd83ae8d2be2d5412d0749308e35af97b963c"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a6f19e07231e411666d780e6b8d858cf6d256de4d7ea1bb17723045e98add53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a6f19e07231e411666d780e6b8d858cf6d256de4d7ea1bb17723045e98add53"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a6f19e07231e411666d780e6b8d858cf6d256de4d7ea1bb17723045e98add53"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b1709a8c5ae6394318b0590c1ae451588e173282749155f5df4e797997f4449"
    sha256 cellar: :any_skip_relocation, ventura:       "9b1709a8c5ae6394318b0590c1ae451588e173282749155f5df4e797997f4449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "944014461e802266d01c8640b7ca2fa8a20e0f67fa439b262e7134c487270fe4"
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
