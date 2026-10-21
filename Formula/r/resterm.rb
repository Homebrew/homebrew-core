class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "c4f19cdee81c248eff543d1cca7d10e5a61e49771073b432ca66ed8bc571e7e0"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cf8ff8106d7cd352e40bab09e85a4557b5b9e3c0b05c6fb4df8894f3f66fdaf8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf8ff8106d7cd352e40bab09e85a4557b5b9e3c0b05c6fb4df8894f3f66fdaf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf8ff8106d7cd352e40bab09e85a4557b5b9e3c0b05c6fb4df8894f3f66fdaf8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0561467ec40a22ee14f08476f8122e16b3c8a5aab486e2fe7cd6a0812f5aa268"
    sha256 cellar: :any,                 x86_64_linux:      "a71391cadfd36e4ddde14c84b4d9775a129496890ffd2c9299575b2d29f6bb63"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
