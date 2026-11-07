class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "6c05f876851673f02b46c5ebfb7de5dccfe09b69cddb07ddda2555e5ac6bb6b1"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bde33cb098fb55f98bc907b86b937a52040603961b36054c51ccca16e33e5385"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bde33cb098fb55f98bc907b86b937a52040603961b36054c51ccca16e33e5385"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bde33cb098fb55f98bc907b86b937a52040603961b36054c51ccca16e33e5385"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1f284931cc409df7ae1d374a1b05c1359892f15aff4707eb4e354c74306431ba"
    sha256 cellar: :any,                 x86_64_linux:      "acf430228de78834314825a0676ca2ffc6c8a7a52e5567dfc959b6b84794c9bd"
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
