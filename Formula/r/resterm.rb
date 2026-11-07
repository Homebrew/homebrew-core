class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "6c05f876851673f02b46c5ebfb7de5dccfe09b69cddb07ddda2555e5ac6bb6b1"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a0c4a12c46de787d859cabdc857a54158674f0220fe5e96473f69376deee678d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a0c4a12c46de787d859cabdc857a54158674f0220fe5e96473f69376deee678d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a0c4a12c46de787d859cabdc857a54158674f0220fe5e96473f69376deee678d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "182fe8a2813fe423b8d724b5a4d07ab3799a0ee3dbc6a6d95b80c9b11a001d31"
    sha256 cellar: :any,                 x86_64_linux:      "50aa15d4566803dc9d106c5c55adc5c2e1761a6657815c832e436fa46dbfce2e"
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
