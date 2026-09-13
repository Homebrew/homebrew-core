class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "3c72153ae58d15d137330fc23ca2878a796f3e7ff9eb8c4505603906540594b4"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b5cc5268d0ffc5cd0db4d23b77b107ba7453ef2fd2dd47baebe75ac0ff9ffbfe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b5cc5268d0ffc5cd0db4d23b77b107ba7453ef2fd2dd47baebe75ac0ff9ffbfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b5cc5268d0ffc5cd0db4d23b77b107ba7453ef2fd2dd47baebe75ac0ff9ffbfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b5cc5268d0ffc5cd0db4d23b77b107ba7453ef2fd2dd47baebe75ac0ff9ffbfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c942dac76983d530e0aaf5150f0a277ffdcfbce62ac4ef31b6d1139d148ea445"
    sha256 cellar: :any,                 x86_64_linux:      "9c5d4a6da31003a8bc6329bde0701d5431d71406de79427959f1aae1b3324035"
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
