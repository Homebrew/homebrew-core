class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "5c14fc30b85c1a28cdbe5b0f0f282d36ad71fe489da6a43d5c6069929737f9be"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18deeb0c7d6d772ca5e84415fec1c12536514353ca67b95a94df712f2554b767"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18deeb0c7d6d772ca5e84415fec1c12536514353ca67b95a94df712f2554b767"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18deeb0c7d6d772ca5e84415fec1c12536514353ca67b95a94df712f2554b767"
    sha256 cellar: :any_skip_relocation, sonoma:        "27e0f8a56adabf3b3e1dd737c46b851bc456631ed6d50761f0fa80cd3381fd93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f9ef501d58e3cde28bbd6ad27fa74e38e5cd00f56ba09882400496172d4cd22"
    sha256 cellar: :any,                 x86_64_linux:  "f679a3d141897ed28d5550ff262e04a858e4d8a5eae895181c105a6a21fca2ae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/resterm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/resterm -version")

    (testpath/"openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
        description: A simple test API
      servers:
        - url: https://api.example.com
          description: Production server
      paths:
        /ping:
          get:
            summary: Ping endpoint
            operationId: ping
            responses:
              "200":
                description: Successful response
                content:
                  application/json:
                    schema:
                      type: object
                      properties:
                        message:
                          type: string
                          example: "pong"
      components:
        schemas:
          PingResponse:
            type: object
            properties:
              message:
                type: string
    YAML

    system bin/"resterm", "--from-openapi", testpath/"openapi.yml",
                          "--http-out",     testpath/"out.http",
                          "--openapi-base-var", "apiBase",
                          "--openapi-server-index", "0"

    assert_match "GET {{apiBase}}/ping", (testpath/"out.http").read
  end
end
