class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.25.5.tar.gz"
  sha256 "38cffd6f70c75bf88722c2d67dc77988f761af29938d438ace51291bde99c5b3"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8c7bd2db9a3767b396e1a4ed36c085559b571f23037c1ef8a8eb929ccb1d1b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50525e0746cb41f8e82907430b7cbf0ed9b03841c58ed3323fa036dafc51aeb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4734b5ba9aa897b742c133a6982fb2c5809a2c1a85c0eb6b19a1da595e60848"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a3a9654bfe4da0cc5b77035bf91f46cf9ad1730c573412ac8979cf0dfee51b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85d6c57ce6a8fe78d4fe45de04625fe1472bccd6f10df97c9550f7a49974f00b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b21d37a816758d29d743356a80b93137418095f1703c57d33d630f1145b0aaa6"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    cd "html-report/ui" do
      system "yarn", "install", "--frozen-lockfile"
      system "yarn", "build"
    end

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
