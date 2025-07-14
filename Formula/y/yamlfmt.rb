class Yamlfmt < Formula
  desc "Extensible command-line tool to format YAML files"
  homepage "https://github.com/google/yamlfmt"
  url "https://github.com/google/yamlfmt/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "bc186eddc322c9a12b0d22e15e1feb54f85ab2ecc9db2cb4837ab770d51a70ea"
  license "Apache-2.0"
  head "https://github.com/google/yamlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f5e9b4d6d6ee0fc7d7faddd555ecbc2934293c0072bec174d24f9db119c4dfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f5e9b4d6d6ee0fc7d7faddd555ecbc2934293c0072bec174d24f9db119c4dfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f5e9b4d6d6ee0fc7d7faddd555ecbc2934293c0072bec174d24f9db119c4dfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "121cb2ca2d54cee82d49d50ccb13ace8be01b19a4e055fcb6c50773f35d450f2"
    sha256 cellar: :any_skip_relocation, ventura:       "121cb2ca2d54cee82d49d50ccb13ace8be01b19a4e055fcb6c50773f35d450f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ec1e9c1f7b02b01ff386ca0bd1f2c490c41133ddbdaac2398eebf13a2eea66d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/yamlfmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlfmt -version")

    (testpath/"test.yml").write <<~YAML
      foo: bar
    YAML
    system bin/"yamlfmt", "-lint", "test.yml"
  end
end
