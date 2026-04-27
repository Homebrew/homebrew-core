class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "9b738c33aac7b0fb74726ffe546ec093b81eea4d9c76c72d14cf08e7c3c5bdc0"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad488f3450ad634545b3b4a324ba6983c0d193b41a9a72f048d3d7e7eb6242ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad488f3450ad634545b3b4a324ba6983c0d193b41a9a72f048d3d7e7eb6242ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad488f3450ad634545b3b4a324ba6983c0d193b41a9a72f048d3d7e7eb6242ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb7da7b669acc90427256e8bdcdbe37c71f380189569ac49c8343b3e09f2215d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e80430fa439cdb668fde9fc4f617eaecf144b7fc7030f79062d09da7440147b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68818224e4dcba5baf2135c894bed463a3f3623d785e788b749649e74dd95812"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/resterm"
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
