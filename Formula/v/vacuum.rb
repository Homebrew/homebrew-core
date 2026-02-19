class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.23.8.tar.gz"
  sha256 "99e747702223882efdc279778721b0127a3e5b609c6d1929046debd64739a4ff"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "685d6196e0f69170b225c8d469ec540f9811454e11140bbb0454a960bc5ab9be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cca24950616dcc3a963fda3996bcee174dd88be549e23e63c0b3825e7a6d60fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "065cf7e09b91ce4f7da1b82e3f363d4fceadd6d2a6e252fd434e8bcb4084516b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d19c9f3d7548a8808f55bb3be5c5bf9b9e8d1615cb58c8c275b4bbecba06846"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c48abf484c32b6113b7ad0c2a4446265507e55014bbad997b2073de2d7b9b6ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f813da8f4202a8da6b7a28e7762353272304a594df374985e6bf49a825fb70e9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vacuum", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vacuum version")

    (testpath/"test-openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
      paths:
        /test:
          get:
            responses:
              '200':
                description: Successful response
    YAML

    output = shell_output("#{bin}/vacuum lint #{testpath}/test-openapi.yml 2>&1", 1)
    assert_match "Failed with 2 errors, 3 warnings and 0 informs.", output
  end
end
