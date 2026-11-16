class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "8c29d188ef9a545fcb748e69a72aa99a3cd38f889b493fb1fb0f54336a8ca3f0"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "39a0b3f59727c96e2c98ba1fe91903bbe57838732db95674ca23c25e638105ee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "39a0b3f59727c96e2c98ba1fe91903bbe57838732db95674ca23c25e638105ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "39a0b3f59727c96e2c98ba1fe91903bbe57838732db95674ca23c25e638105ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "17831f30247b369cec25ade978048927f0f79800f05cbd4e866ea7c21d10ae85"
    sha256 cellar: :any,                 x86_64_linux:      "a538010d6ea7effed1f810a327acc958990bfc677cb30aed93fc8f3084555e6a"
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
