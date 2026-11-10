class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "618932c49c9aedf16bbb004e6de2bb069da78cecc1e034483d7fc90a6e7cb1f6"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b1bfc740be4fbcbf4f9c954597916ab138699fe0056499481837cef9e8ee4a5b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b1bfc740be4fbcbf4f9c954597916ab138699fe0056499481837cef9e8ee4a5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1bfc740be4fbcbf4f9c954597916ab138699fe0056499481837cef9e8ee4a5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dcf3a43e52ce2dab30fec654cc1e38cb406b7dbb7a5bd85b5f4801e5185ef666"
    sha256 cellar: :any,                 x86_64_linux:      "1cb36b693b0764ed824095387553c1b9bc30380e11474ccb74e039cfd09e946f"
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
